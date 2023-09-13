//
//  GuaranteeYesNoView.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import QMUIKit

class GuaranteeYesNoView: UIView {
    
    weak var ovc: OverlayController?
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "home_create_wallet_noti_title".toMultilingualism()
            notiLabel.textColor = ColorConfiguration.blackText.toColor()
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.qmui_lineHeight = 22
            contentLabel.textColor = ColorConfiguration.blackText.toColor()
            contentLabel.text = "home_create_wallet_noti_content".toMultilingualism()
        }
    }
    
    @IBOutlet weak var goNowButton: UIButton! {
        didSet {
            goNowButton.setTitle("home_gonow_button".toMultilingualism(), for: .normal)
            goNowButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            goNowButton.layer.cornerRadius = 10
            goNowButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var afterButton: UIButton! {
        didSet {
            afterButton.setTitle("home_after_button".toMultilingualism(), for: .normal)
            afterButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            afterButton.layer.cornerRadius = 10
            afterButton.layer.borderWidth = 1
            afterButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
        }
    }
    
    @IBOutlet weak var titleIcon: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    
    public static func showFromBottom(image: UIImage?, title: String?, titleIcon: UIImage?, content: String?, leftButton: String?, rightButton: String?) -> Observable<Int> {
        
        return Observable.create { o in
            
            guard let topVc = AppDelegate.topViewController() else {
                return Disposables.create {}
            }
            var baseHeight: CGFloat = 474
            let width = topVc.view.bounds.width
            
            let calculateHeightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30, height: .greatestFiniteMagnitude))
            calculateHeightLabel.numberOfLines = 0
            calculateHeightLabel.lineBreakMode = .byWordWrapping
            calculateHeightLabel.font = UIFont.systemFont(ofSize: 15)
            var tempStr = ""
            if let t = title {
                tempStr = t
            }
            if let c = content {
                tempStr += "\n\(c)"
            }
            calculateHeightLabel.text = tempStr
            calculateHeightLabel.sizeToFit()
            baseHeight += calculateHeightLabel.frame.height
            
            let contentView: GuaranteeYesNoView = ViewLoader.Xib.view()
            contentView.frame = CGRect(x: 0, y: 0, width: topVc.view.bounds.width, height: baseHeight)
            
            let ovc = OverlayController(view: contentView)
            contentView.ovc = ovc
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            
            contentView.do { it in
                it.applyCornerRadius(10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
                it.notiLabel.text = title
                it.contentLabel.text = content
                it.imageView.image = image
                it.titleIcon.image = titleIcon
                
                if let leftStr = leftButton {
                    it.afterButton.setTitle(leftStr, for: .normal)
                } else {
                    it.afterButton.removeFromSuperview()
                }
                
                if let rightStr = rightButton {
                    it.goNowButton.setTitle(rightStr, for: .normal)
                } else {
                    it.afterButton.removeFromSuperview()
                }
                
                it.goNowButton.rx.tap.subscribe(onNext: { _ in
                    o.onNext(1)
                    o.onCompleted()
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                }).disposed(by: ovc.rx.disposeBag)
                
                it.afterButton.rx.tap.subscribe(onNext: { _ in
                    o.onNext(0)
                    o.onCompleted()
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                }).disposed(by: ovc.rx.disposeBag)
            }
            
            return Disposables.create {}
        }
    }
    
    
    public static func showFromCenter(image: UIImage?, title: String?, titleIcon: UIImage?, content: String?, leftButton: String?, rightButton: String?) -> Observable<Int> {
        
        return Observable.create { o in
            
            guard let topVc = AppDelegate.topViewController() else {
                return Disposables.create {}
            }
            var baseHeight: CGFloat = 380
            let width = topVc.view.bounds.width - 82
            
            let calculateHeightLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width - 30 - 82, height: .greatestFiniteMagnitude))
            calculateHeightLabel.numberOfLines = 0
            calculateHeightLabel.lineBreakMode = .byWordWrapping
            calculateHeightLabel.font = UIFont.systemFont(ofSize: 15)
            var tempStr = ""
            if let t = title {
                tempStr = t
            }
            if let c = content {
                tempStr += "\n\(c)"
            }
            calculateHeightLabel.text = tempStr
            calculateHeightLabel.sizeToFit()
            baseHeight += calculateHeightLabel.frame.height
            
            let contentView: GuaranteeYesNoView = ViewLoader.Xib.view()
            contentView.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
            
            let ovc = OverlayController(view: contentView)
            contentView.ovc = ovc
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .center
            ovc.presentationStyle = .transform(scale: 1.5)
            ovc.dismissonStyle = .transform(scale: 0.5)
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            
            contentView.do { it in
                it.applyCornerRadius(10)
                it.notiLabel.text = title
                it.contentLabel.text = content
                it.imageView.image = image
                it.titleIcon.image = titleIcon
                
                if let leftStr = leftButton {
                    it.afterButton.setTitle(leftStr, for: .normal)
                } else {
                    it.afterButton.removeFromSuperview()
                }
                
                if let rightStr = rightButton {
                    it.goNowButton.setTitle(rightStr, for: .normal)
                } else {
                    it.afterButton.removeFromSuperview()
                }
                
                it.goNowButton.rx.tap.subscribe(onNext: { _ in
                    o.onNext(1)
                    o.onCompleted()
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                }).disposed(by: ovc.rx.disposeBag)
                
                it.afterButton.rx.tap.subscribe(onNext: { _ in
                    o.onNext(0)
                    o.onCompleted()
                    if let container = it.ovc {
                        topVc.view.dissmiss(overlay: container)
                    }
                }).disposed(by: ovc.rx.disposeBag)
            }
            
            return Disposables.create {}
        }
    }
}
