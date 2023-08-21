//
//  GuaranteeFeesView.swift
//  WalletX
//
//  Created by DZSB-001968 on 21.8.23.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import QMUIKit

class GuaranteeFeesView: UIView {

    @IBOutlet weak var bulbLabel: UILabel! {
        didSet {
            bulbLabel.text = "home_fee_noti".toMultilingualism()
            bulbLabel.textColor = ColorConfiguration.blackText.toColor()
        }
    }
    
    @IBOutlet weak var noNotiButton: UIButton! {
        didSet {
            let spacing: CGFloat = 10
            noNotiButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            noNotiButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            noNotiButton.setTitle("home_no_noti_again".toMultilingualism(), for: .normal)
            noNotiButton.setTitleColor(ColorConfiguration.descriptionText.toColor(), for: .normal)
            noNotiButton.setImage(UIImage(named: "guarantee_check_box1"), for: .normal)
            noNotiButton.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            noNotiButton.sizeToFit()
        }
    }
    
    @IBOutlet weak var contactServerButton: UIButton! {
        didSet {
            contactServerButton.setTitle("home_contact_us".toMultilingualism(), for: .normal)
            contactServerButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            contactServerButton.layer.cornerRadius = 10
            contactServerButton.layer.borderWidth = 1
            contactServerButton.layer.borderColor = ColorConfiguration.primary.toColor().cgColor
        }
    }
    
    @IBOutlet weak var IKnowButton: UIButton! {
        didSet {
            IKnowButton.setTitle("home_gotit".toMultilingualism(), for: .normal)
            IKnowButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            IKnowButton.layer.cornerRadius = 10
            IKnowButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.qmui_lineHeight = 26
            contentLabel.textColor = ColorConfiguration.blackText.toColor()
            contentLabel.text = "home_fee_noti_content".toMultilingualism()
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
            
            let contentView: GuaranteeFeesView = ViewLoader.Xib.view()
            contentView.frame = CGRect(x: 0, y: 0, width: topVc.view.bounds.width, height: 615)
            contentView.applyCornerRadius(10, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
            let ovc = OverlayController(view: contentView)
            ovc.isDismissOnMaskTouched = false
            ovc.layoutPosition = .bottom
            ovc.presentationStyle = .fromToBottom
            ovc.maskStyle = .black(opacity: 0.5)
            topVc.view.present(overlay: ovc)
            
            contentView.do { it in
                it.IKnowButton.rx.tap.subscribe(onNext: { _ in
                
                    o.onNext(1)
                    o.onCompleted()
                    topVc.view.dissmiss(overlay: ovc)
                }).disposed(by: ovc.rx.disposeBag)
                
                it.contactServerButton.rx.tap.subscribe(onNext: { _ in
                
                    o.onNext(0)
                    o.onCompleted()
                    topVc.view.dissmiss(overlay: ovc)
                }).disposed(by: ovc.rx.disposeBag)
                
                
                it.noNotiButton.rx.tap.subscribe(onNext: {[weak it] _ in
                
                    it?.noNotiButton.isSelected = true
                    
                }).disposed(by: ovc.rx.disposeBag)
            }
            
            return Disposables.create {}
        }
    }
    
}
