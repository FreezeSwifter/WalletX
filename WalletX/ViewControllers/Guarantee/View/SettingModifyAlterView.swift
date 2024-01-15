//
//  SettingModifyAlterView.swift
//  WalletX
//
//  Created by DZSB-001968 on 7.9.23.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import QMUIKit

class SettingModifyAlterView: UIView {
    
    weak var oc: OverlayController?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textFieldBg: UIView! {
        didSet {
            textFieldBg.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
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
    
    static func show(title: String?, text: String?, placeholder: String?, leftButtonTitle: String?, rightButtonTitle: String?) -> Observable<String?> {
        return Observable<String?>.create { o in
            guard let topVc = AppDelegate.topViewController() else {
                return Disposables.create {}
            }
            
            let baseHeight: CGFloat = 220
            let width = topVc.view.bounds.width - 80
            
            let contentView: SettingModifyAlterView = ViewLoader.Xib.view()
            
            contentView.do { it in
                it.frame = CGRect(x: 0, y: 0, width: width, height: baseHeight)
                it.layer.cornerRadius = 10
                if let leftBtn = leftButtonTitle {
                    it.leftButton.setupAPPUIHollowStyle(title: leftBtn)
                } else {
                    it.leftButton.removeFromSuperview()
                }
                
                if let rightBtn = rightButtonTitle {
                    it.rightButton.setupAPPUISolidStyle(title: rightBtn)
                } else {
                    it.rightButton.removeFromSuperview()
                }
                it.titleLabel.text = title
                it.textField.text = text
                it.textField.placeholder = placeholder
                it.leftButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
                
                it.rightButton.rx.tap.subscribe(onNext: {[weak it] _ in
                    o.onNext(it?.textField.text)
                    if let oc = it?.oc {
                        topVc.view.dissmiss(overlay: oc)
                    }
                }).disposed(by: it.rx.disposeBag)
            }
            
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = true
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
