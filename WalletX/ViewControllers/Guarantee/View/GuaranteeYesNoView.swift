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

    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "home_create_wallet_noti_title".toMultilingualism()
            notiLabel.textColor = ColorConfiguration.blackText.toColor()
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.qmui_lineHeight = 26
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

    
    public static func show() -> Observable<Int> {
        
        return Observable.create { o in
            
            guard let topVc = AppDelegate.topViewController() else {
                return Disposables.create {}
            }
            
            let contentView: GuaranteeYesNoView = ViewLoader.Xib.view()
            contentView.frame = CGRect(x: 0, y: 0, width: topVc.view.bounds.width, height: 520)
            contentView.applyCornerRadius(10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            
            contentView.do { it in
                it.goNowButton.rx.tap.subscribe(onNext: { _ in
                
                    o.onNext(1)
                    o.onCompleted()
                    topVc.view.dissmiss(overlay: ovc)
                }).disposed(by: ovc.rx.disposeBag)
                
                it.afterButton.rx.tap.subscribe(onNext: { _ in
                
                    o.onNext(0)
                    o.onCompleted()
                    topVc.view.dissmiss(overlay: ovc)
                }).disposed(by: ovc.rx.disposeBag)
                
            }
            
            return Disposables.create {}
        }
    }
}
