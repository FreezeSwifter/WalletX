//
//  OrderOperationViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 29.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import SwiftDate

class OrderOperationViewController: UIViewController, HomeNavigationble {
    
    var assureId: String?
    
    private var model: GuaranteeInfoModel?
    
    var state: OrderOperationGuarantee = .applyRelease {
        didSet {
            headerView?.titleLabel.text = state.title
        }
    }
    
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel!
    
    @IBOutlet weak var desLabel3: UILabel!
    
    @IBOutlet weak var desLabel4: UILabel!

    @IBOutlet weak var desLabel4Me: UILabel! {
        didSet {
            desLabel4Me.text = "我".toMultilingualism()
            desLabel4Me.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            desLabel4Me.minimumScaleFactor = 0.5
            desLabel4Me.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            desLabel5Me.minimumScaleFactor = 0.5
            desLabel5Me.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel!
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.minimumScaleFactor = 0.5
            valueLabel1.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel1State: QMUILabel! {
        didSet {
            valueLabel1State.minimumScaleFactor = 0.5
            valueLabel1State.adjustsFontSizeToFitWidth = true
            valueLabel1State.contentEdgeInsets = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
            valueLabel1State.applyCornerRadius(4)
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.minimumScaleFactor = 0.5
            valueLabel2.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.minimumScaleFactor = 0.5
            valueLabel3.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel! {
        didSet {
            valueLabel4.minimumScaleFactor = 0.5
            valueLabel4.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel5: UILabel! {
        didSet {
            valueLabel5.minimumScaleFactor = 0.5
            valueLabel5.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(OrderOperationViewController.protocolTap))
            protocolBg.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var protocolLabel: UILabel! {
        didSet {
            protocolLabel.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel4Sub: UILabel! {
        didSet {
            valueLabel4Sub.minimumScaleFactor = 0.5
            valueLabel4Sub.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel5Sub: UILabel! {
        didSet {
            valueLabel5Sub.minimumScaleFactor = 0.5
            valueLabel5Sub.adjustsFontSizeToFitWidth = true
        }
    }
    
    
    @IBOutlet weak var desLabel20: UILabel!

    @IBOutlet weak var valueLabel20: UILabel! {
        didSet {
            valueLabel20.minimumScaleFactor = 0.5
            valueLabel20.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel7: UILabel!
    
    @IBOutlet weak var desLabel8: UILabel!
    
    @IBOutlet weak var desLabel9: UILabel!
    
    @IBOutlet weak var desLabel10: UILabel!
    
    @IBOutlet weak var tradeCompletedButton: QMUIButton! {
        didSet {
            tradeCompletedButton.setImage(UIImage(named: "me_checkbox2"), for: .selected)
            tradeCompletedButton.setTitle("交易结束".toMultilingualism(), for: .normal)
            tradeCompletedButton.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var tradeCancelButton: QMUIButton! {
        didSet {
            tradeCancelButton.setImage(UIImage(named: "me_checkbox2"), for: .selected)
            tradeCancelButton.setTitle("交易取消".toMultilingualism(), for: .normal)
            tradeCancelButton.spacingBetweenImageAndTitle = 10
            
        }
    }
    
    @IBOutlet weak var explainButton: QMUIButton! {
        didSet {
            explainButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            explainButton.spacingBetweenImageAndTitle = 4
            explainButton.backgroundColor = ColorConfiguration.primary.toColor().withAlphaComponent(0.1)
            explainButton.setTitleColor(ColorConfiguration.primary.toColor(), for: .normal)
            explainButton.setTitle("说明".toMultilingualism(), for: .normal)
        }
    }

    
    @IBOutlet weak var accountButton1: QMUIButton! {
        didSet {
            accountButton1.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            accountButton1.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var accountButton2: QMUIButton! {
        didSet {
            accountButton2.setImage(UIImage(named: "guarantee_check_box2"), for: .selected)
            accountButton2.spacingBetweenImageAndTitle = 10
        }
    }
    
    @IBOutlet weak var valueLabel6: UILabel! {
        didSet {
            valueLabel6.minimumScaleFactor = 0.5
            valueLabel6.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel7: UILabel! {
        didSet {
            valueLabel7.minimumScaleFactor = 0.5
            valueLabel7.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel8: UILabel! {
        didSet {
            valueLabel8.minimumScaleFactor = 0.5
            valueLabel8.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var textFieldBg1: UIView! {
        didSet {
            textFieldBg1.clipsToBounds = true
            textFieldBg1.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textFieldBg2: UIView! {
        didSet {
            textFieldBg2.clipsToBounds = true
            textFieldBg2.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var textField1: UITextField! {
        didSet {
            textField1.placeholder = "请输入金额".toMultilingualism()
            textField1.keyboardType = .decimalPad
            textField1.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var textField2: UITextField! {
        didSet {
            textField2.placeholder = "请输入金额".toMultilingualism()
            textField2.keyboardType = .decimalPad
            textField2.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel6: UILabel!
    
    @IBOutlet weak var walletDesLabel: UILabel! {
        didSet {
            walletDesLabel.text = "钱包账户".toMultilingualism()
        }
    }
    
    @IBOutlet weak var walletBg: UIView! {
        didSet {
            walletBg.clipsToBounds = true
            walletBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var walletTextField: UITextField! {
        didSet {
            walletTextField.placeholder = nil
            walletTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var addressCopyButton: UIButton! {
        didSet {
            addressCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
            addressCopyButton.titleLabel?.adjustsFontSizeToFitWidth = true
            addressCopyButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var buttonLeftButton: UIButton! {
        didSet {
            buttonLeftButton.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
        }
    }
    
    @IBOutlet weak var bottomRightButton: UIButton! {
        didSet {
            bottomRightButton.setupAPPUISolidStyle(title: "立即申请".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        switch state {
        case .applyRelease:
            buttonLeftButton.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            bottomRightButton.setupAPPUISolidStyle(title: "立即申请".toMultilingualism())
            textField1.text = nil
            textField2.text = nil
            
        case .handling:
            textField1.isUserInteractionEnabled = false
            textField2.isUserInteractionEnabled = false
            tradeCancelButton.isUserInteractionEnabled = false
            tradeCompletedButton.isUserInteractionEnabled = false
            bottomRightButton.setupAPPUISolidStyle(title: "同意解押".toMultilingualism())
            buttonLeftButton.setupAPPUIHollowStyle(title: "拒绝解押".toMultilingualism())
            
        case .revoke:
            textField1.isUserInteractionEnabled = false
            textField2.isUserInteractionEnabled = false
            tradeCancelButton.isUserInteractionEnabled = false
            tradeCompletedButton.isUserInteractionEnabled = false
            accountButton1.isEnabled = false
            accountButton2.isEnabled = false
            bottomRightButton.setupAPPUISolidStyle(title: "撤销申请".toMultilingualism())
        }
        
        desLabel2.text = "发起时间".toMultilingualism()
        desLabel3.text = "上押时间".toMultilingualism()
        desLabel20.text = "担保金额没有1".toMultilingualism()
        desLabel4.text = "发起人".toMultilingualism()
        desLabel5.text = "参与人".toMultilingualism()
        desLabel6.text = "担保时长".toMultilingualism()
        desLabel7.text = "担保费用".toMultilingualism()
        desLabel8.text = "可解金额".toMultilingualism()
        desLabel9.text = "解押原因".toMultilingualism()
        desLabel10.text = "收款账户".toMultilingualism()
        
        if let id = assureId {
            let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.releaseInfo(assureId: id)).mapModel()
            req.subscribe(onNext: {[weak self] obj in
                self?.model = obj
                self?.valueLabel1.text = id
                self?.valueLabel2.text = Date(timeIntervalSince1970: (obj?.data?.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
                self?.valueLabel3.text = Date(timeIntervalSince1970: (obj?.data?.multisigTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
                let amount = NSMutableAttributedString(string: "\(obj?.data?.amount ?? 0) USDT")
                self?.valueLabel20.textColor = ColorConfiguration.lightBlue.toColor()
                amount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
                self?.valueLabel20.attributedText = amount
                self?.valueLabel4.text = obj?.data?.sponsorUserName ?? "--"
                self?.valueLabel5.text = obj?.data?.partnerUserName ?? "--"
                
                let sponsorReleasedAmount = NSMutableAttributedString(string: "\(obj?.data?.sponsorReleasedAmount ?? 0) USDT")
                self?.valueLabel4Sub.textColor = ColorConfiguration.lightBlue.toColor()
                sponsorReleasedAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
                self?.valueLabel4Sub.attributedText = sponsorReleasedAmount
                
                let partnerReleasedAmount = NSMutableAttributedString(string: "\(obj?.data?.partnerReleasedAmount ?? 0) USDT")
                self?.valueLabel5Sub.textColor = ColorConfiguration.lightBlue.toColor()
                partnerReleasedAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
                self?.valueLabel5Sub.attributedText = partnerReleasedAmount
                
                self?.valueLabel6.text = obj?.data?.duration?.description
                self?.valueLabel7.text = "\(obj?.data?.assureFee ?? 0)"
                self?.valueLabel8.text = "\(obj?.data?.releaseAmountCan ?? 0)"
                
                self?.valueLabel4Sub.text = "\(obj?.data?.sponsorAmount ?? 0)"
                self?.valueLabel5Sub.text = "\(obj?.data?.partnerAmount ?? 0)"
    
                self?.tradeCompletedButton.isSelected = true
                
                self?.accountButton1.setTitle(obj?.data?.sponsorUserName, for: .normal)
                self?.accountButton2.setTitle(obj?.data?.partnerUserName, for: .normal)
    
                if !(self?.state == .applyRelease) {
                    self?.textField1.text = "\(obj?.data?.sponsorReleasedAmount ?? 0.0)"
                    self?.textField2.text = "\(obj?.data?.partnerReleasedAmount ?? 0.0)"
                }
             
                if obj?.data?.assureType == 0 {
                    self?.walletBg.isHidden = true
                    self?.walletDesLabel.isHidden = true
                } else {
                    self?.walletBg.isHidden = false
                    self?.walletTextField.text = obj?.data?.multisigAddress
                }
                
                if obj?.data?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                    self?.desLabel4Me.isHidden = false
                    self?.desLabel5Me.isHidden = true
                    
                } else {
                    self?.desLabel4Me.isHidden = true
                    self?.desLabel5Me.isHidden = false
                }
                
                if obj?.data?.assureStatus == 2 {
                    self?.valueLabel1State.backgroundColor = UIColor(hex: "#28C445").withAlphaComponent(0.1)
                    self?.valueLabel1State.textColor = UIColor(hex: "#28C445")
                    self?.valueLabel1State.text = "me_guaranteeing".toMultilingualism()
                    
                } else if obj?.data?.assureStatus == 9 {
                    self?.valueLabel1State.backgroundColor = UIColor(hex: "#7241FF").withAlphaComponent(0.1)
                    self?.valueLabel1State.textColor = UIColor(hex: "#7241FF")
                    self?.valueLabel1State.text = "me_releasing".toMultilingualism()
                }
                
            }).disposed(by: rx.disposeBag)
        }
        
        addressCopyButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.walletTextField.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        tradeCompletedButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.tradeCompletedButton.isSelected = true
            self?.tradeCancelButton.isSelected = false
        }).disposed(by: rx.disposeBag)
        
        tradeCancelButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.tradeCancelButton.isSelected = true
            self?.tradeCompletedButton.isSelected = false
        }).disposed(by: rx.disposeBag)
        
        bottomRightButton.rx.tap.subscribe(onNext: {[weak self] in
            guard let this = self, let id = this.model?.data?.assureId else { return }
            
            if this.bottomRightButton.titleLabel?.text == "立即申请".toMultilingualism() {
                let reason = this.tradeCompletedButton.isSelected ? 0 : 1
                let sponsorReleasedAmount = this.textField1.text ?? "0"
                let partnerReleasedAmount = this.textField2.text ?? "0"
                let add = (Double(sponsorReleasedAmount) ?? 0) + (Double(partnerReleasedAmount) ?? 0)
                if this.model?.data?.releaseAmountCan != add && this.accountButton1.isSelected && this.accountButton2.isSelected {
                    APPHUD.flash(text: "发起人和参与人输入的金额之和必须等于可解押金额".toMultilingualism())
                    return
                }
                
                APIProvider.rx.request(.assureReleaseApply(assureId: id, reason: reason, sponsorReleasedAmount: sponsorReleasedAmount, partnerReleasedAmount: partnerReleasedAmount)).mapJSON().subscribe(onSuccess: {[weak self] obj in
                    guard let dict = obj as? [String: Any], let this = self else { return }
                    let code = dict["code"] as? Int
                    if code == 0 {
                        let titleIcon = UIImage(named: "wallet_noti2")?.qmui_image(withTintColor: ColorConfiguration.primary.toColor())
                        GuaranteeYesNoView.showFromBottom(image: UIImage(named: "me_release_apply"), title: "解押通知".toMultilingualism(), titleIcon: titleIcon, content: "解押通知内容".toMultilingualism(), leftButton: "通知对方".toMultilingualism(), rightButton: "完成".toMultilingualism()).subscribe(onNext: {[weak self] index in
                            
                            if index == 0 {
                                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                                vc.orderInfoModel = self?.model?.data
                                if self?.model?.data?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                                    vc.walletId = self?.model?.data?.partnerUser
                                } else {
                                    vc.walletId = self?.model?.data?.sponsorUser
                                }
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            if index == 1 {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        }).disposed(by: this.rx.disposeBag)
                        
                    } else {
                        APPHUD.flash(text: dict["message"] as? String)
                    }
                }).disposed(by: this.rx.disposeBag)
                
            } else if this.bottomRightButton.titleLabel?.text == "撤销申请".toMultilingualism() {
             
                APIProvider.rx.request(.revokeAssureApply(assureId: id)).mapJSON().subscribe(onSuccess: { [weak self] obj in
                    
                    guard let dict = obj as? [String: Any], let this = self else { return }
                    let code = dict["code"] as? Int
                    if code == 0 {
                        
                        let titleIcon = UIImage(named: "guarantee_bulb")?.qmui_image(withTintColor: ColorConfiguration.primary.toColor())
                        GuaranteeYesNoView.showFromBottom(image: UIImage(named: "me_revoke_img"), title: "您已成功取消解押申请".toMultilingualism(), titleIcon: titleIcon, content: "您已成功取消解押申请内容".toMultilingualism(), leftButton: "通知对方".toMultilingualism(), rightButton: "完成".toMultilingualism()).subscribe(onNext: { index in
                            
                            if index == 0 {
                                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                                vc.orderInfoModel = self?.model?.data
                                if self?.model?.data?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                                    vc.walletId = self?.model?.data?.sponsorUser
                                } else {
                                    vc.walletId = self?.model?.data?.sponsorUser
                                }
                                self?.navigationController?.pushViewController(vc, animated: true)
                                
                            } else {
                                self?.navigationController?.popViewController(animated: true)
                            }
                            
                        }).disposed(by: this.rx.disposeBag)
                        
                    } else {
                        APPHUD.flash(text: dict["message"] as? String)
                    }
                    
                }).disposed(by: this.rx.disposeBag)
                
            } else if this.bottomRightButton.titleLabel?.text == "同意解押".toMultilingualism() {
                
                let titleIcon = UIImage(named: "guarantee_bulb")
                GuaranteeYesNoView.showFromCenter(image: UIImage(named: "guarantee_yes_no"), title: "您确定要同意这个解押申请吗".toMultilingualism(), titleIcon: titleIcon, content: "您确定要同意这个解押申请吗内容".toMultilingualism(), leftButton: "取消".toMultilingualism(), rightButton: "确定".toMultilingualism()).subscribe(onNext: {[weak self] index in
                    if index == 1 {
                        self?.agreeRelease()
                    }
                    
                }).disposed(by: this.rx.disposeBag)
                
            }
            
        }).disposed(by: rx.disposeBag)
        
        buttonLeftButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            if self?.buttonLeftButton.titleLabel?.text == "拒绝解押".toMultilingualism() {
                guard let id = self?.model?.data?.assureId else { return }
                APIProvider.rx.request(.assureOrderReleaseReject(assureId: id)).mapJSON().subscribe(onSuccess: { obj in
                    
                    guard let dict = obj as? [String: Any], let code = dict["code"] as? Int else { return }
                    if code != 0 {
                        APPHUD.flash(text: dict["message"] as? String)
                    } else {
                        APPHUD.flash(text: "成功".toMultilingualism())
                    }
                }).disposed(by: this.rx.disposeBag)
                
            } else if self?.buttonLeftButton.titleLabel?.text == "联系对方".toMultilingualism() {
                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                vc.orderInfoModel = self?.model?.data
                if self?.model?.data?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                    vc.walletId = self?.model?.data?.partnerUser
                } else {
                    vc.walletId = self?.model?.data?.sponsorUser
                }
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
        
        accountButton1.rx.tap.subscribe(onNext: {[unowned self] _ in
            self.accountButton1.isSelected = !self.accountButton1.isSelected
            if !self.accountButton1.isSelected {
                self.textField1.text = nil
            }
            self.textField1.isUserInteractionEnabled = self.accountButton1.isSelected
        }).disposed(by: rx.disposeBag)
        
        accountButton2.rx.tap.subscribe(onNext: {[unowned self] _ in
            self.accountButton2.isSelected = !self.accountButton2.isSelected
            
            if !self.accountButton2.isSelected {
                self.textField2.text = nil
            }
            self.textField2.isUserInteractionEnabled = self.accountButton2.isSelected
        }).disposed(by: rx.disposeBag)
        
        explainButton.rx.tap.subscribe(onNext: {[unowned self] in
           
            NotiAlterView.show(title: "担保费用收费标准".toMultilingualism(), content: "担保费用收费标准内容".toMultilingualism(), leftButtonTitle: "联系客服".toMultilingualism(), rightButtonTitle: "知道啦".toMultilingualism())
                .subscribe(onNext: { index in
                    if index == 0 {
                        let app = UIApplication.shared.delegate as? AppDelegate
                        app?.openTg()
                    }
                }).disposed(by: rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = state.title
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        desLabel5Me.snp.remakeConstraints { make in
            make.width.height.equalTo(26)
        }
        desLabel5Me.clipsToBounds = true
        desLabel5Me.layer.cornerRadius = 13
        
        desLabel4Me.snp.remakeConstraints { make in
            make.width.height.equalTo(26)
        }
        desLabel4Me.clipsToBounds = true
        desLabel4Me.layer.cornerRadius = 13
    }
    
    @objc
    private func protocolTap() {
        NotiAlterView.show(title: "协议".toMultilingualism(), content: model?.data?.agreement, leftButtonTitle: nil, rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in

        }).disposed(by: rx.disposeBag)
    }
    
    private func agreeRelease() {
        guard let id = model?.data?.assureId else { return }
        let key = LocaleWalletManager.shared().currentWallet?.getKeyForCoin(coin: .tron).data.hexString ?? ""
        APIProvider.rx.request(.releaseAgree(assureId: id, privateKey: key)).mapJSON().subscribe(onSuccess: {[weak self] obj in
            
            guard let dict = obj as? [String: Any], let this = self else { return }
            let message = dict["message"] as? String
            if message.isNilOrEmpty {

                let titleIcon = UIImage(named: "me_revoke_img")?.qmui_image(withTintColor: ColorConfiguration.primary.toColor())
                GuaranteeYesNoView.showFromBottom(image: UIImage(named: "me_dollar_mobile"), title: "您已批准对方的解押申请".toMultilingualism(), titleIcon: titleIcon, content: "您已批准对方的解押申请内容".toMultilingualism(), leftButton: "通知对方".toMultilingualism(), rightButton: "完成".toMultilingualism()).subscribe(onNext: { index in
                    
                    if index == 1 {
                        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                    }
                    
                }).disposed(by: this.rx.disposeBag)
                
            } else {
                APPHUD.flash(text: message)
            }
            
        }).disposed(by: rx.disposeBag)
    }
}
