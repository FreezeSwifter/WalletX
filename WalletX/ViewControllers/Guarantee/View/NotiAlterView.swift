//
//  NotiAlterView.swift
//  WalletX
//
//  Created by DZSB-001968 on 23.8.23.
//

import Foundation
import Then
import RxCocoa
import RxSwift
import QMUIKit

class NotiAlterView: UIView {
    
    weak var oc: OverlayController?
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.textColor = ColorConfiguration.blodText.toColor()
            topLabel.minimumScaleFactor = 0.5
            topLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.textColor = ColorConfiguration.blackText.toColor()
            contentLabel.minimumScaleFactor = 0.5
            contentLabel.adjustsFontSizeToFitWidth = true
            contentLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    @IBOutlet weak var leftButton: UIButton! {
        didSet {
            leftButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            leftButton.layer.cornerRadius = 10
            leftButton.layer.borderWidth = 1
            leftButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
        }
    }
    
    @IBOutlet weak var rightButton: UIButton! {
        didSet {
            rightButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            rightButton.layer.cornerRadius = 10
            rightButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
    }
    
    
    static func show(title: String?, content: String?, leftButtonTitle: String?, rightButtonTitle: String?) -> Observable<Int> {
        
        return Observable.create { o in
            guard let topVc = AppDelegate.topViewController() else {
                return Disposables.create {}
            }
            var baseHeight: CGFloat = 165
            let width = topVc.view.bounds.width - 80
            
            let calculateHeightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: .greatestFiniteMagnitude))
            calculateHeightLabel.numberOfLines = 0
            calculateHeightLabel.lineBreakMode = .byWordWrapping
            calculateHeightLabel.font = UIFont.systemFont(ofSize: 15)
            calculateHeightLabel.text = content
            calculateHeightLabel.sizeToFit()
            baseHeight += calculateHeightLabel.frame.height
            
            let contentView: NotiAlterView = ViewLoader.Xib.view()
    
            contentView.do { it in
                it.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
                it.layer.cornerRadius = 10
                if let leftBtn = leftButtonTitle {
                    it.leftButton.setTitle(leftBtn, for: .normal)
                } else {
                    it.leftButton.removeFromSuperview()
                }
                
                if let rightBtn = rightButtonTitle {
                    it.rightButton.setTitle(rightBtn, for: .normal)
                } else {
                    it.rightButton.removeFromSuperview()
                }
                it.topLabel.text = title
                it.contentLabel.text = content
                
                it.leftButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(0)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
                
                it.rightButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(1)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
            }
            
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .center
            ovc.presentationStyle = .transform(scale: 1.5)
            ovc.dismissonStyle = .transform(scale: 0.5)
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            contentView.oc = ovc
            
            return Disposables.create {}
        }
    }
}
