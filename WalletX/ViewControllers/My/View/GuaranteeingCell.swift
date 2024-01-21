//
//  GuaranteeingCell.swift
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
import QMUIKit
import SwiftDate
import MZTimerLabel

class GuaranteeingCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel! {
        didSet {
            tagLabel.minimumScaleFactor = 0.5
            tagLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var concact: UIStackView! {
        didSet {
            concact.isLayoutMarginsRelativeArrangement = true
            concact.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            concact.applyCornerRadius(concact.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(GuaranteeingCell.contactTap))
            concact.addGestureRecognizer(ges)
        }
    }
    @IBOutlet weak var serviceLabel: UILabel! {
        didSet {
            serviceLabel.text = "客服".toMultilingualism()
            serviceLabel.minimumScaleFactor = 0.5
            serviceLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "担保金额没有1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "发起人".toMultilingualism()
        }
    }

    @IBOutlet weak var desLabel4Me: UILabel! {
        didSet {
            desLabel4Me.text = "我".toMultilingualism()
            desLabel4Me.isHidden = true
        }
    }
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.isHidden = true
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.minimumScaleFactor = 0.9
            valueLabel1.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel1Status: QMUILabel! {
        didSet {
            valueLabel1Status.minimumScaleFactor = 0.5
            valueLabel1Status.adjustsFontSizeToFitWidth = true
            valueLabel1Status.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
            valueLabel1Status.applyCornerRadius(8)
            valueLabel1Status.backgroundColor = UIColor(hex: "#28C445").withAlphaComponent(0.1)
            valueLabel1Status.textColor = UIColor(hex: "#28C445")
            valueLabel1Status.minimumScaleFactor = 0.5
            valueLabel1Status.adjustsFontSizeToFitWidth = true
        }
    }

    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(GuaranteeingCell.protocolTap))
            protocolBg.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var protocolLabel: UILabel! {
        didSet {
            protocolLabel.text = "协议".toMultilingualism()
            protocolLabel.adjustsFontSizeToFitWidth = true
            protocolLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.minimumScaleFactor = 0.9
            valueLabel2.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.minimumScaleFactor = 0.9
            valueLabel3.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel! {
        didSet {
            valueLabel4.minimumScaleFactor = 0.9
            valueLabel4.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel5: UILabel! {
        didSet {
            valueLabel5.minimumScaleFactor = 0.9
            valueLabel5.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel5sub: UILabel! {
        didSet {
            valueLabel5sub.minimumScaleFactor = 0.5
            valueLabel5sub.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel4sub: UILabel! {
        didSet {
            valueLabel4sub.minimumScaleFactor = 0.5
            valueLabel4sub.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var superLinkLabel: UILabel! {
        didSet {
            superLinkLabel.text = "hyperlink".toMultilingualism()
        }
    }
    
    @IBOutlet weak var superLinkValueLabel: UILabel! {
        didSet {
            superLinkValueLabel.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
            superLinkValueLabel.addGestureRecognizer(tap)
        }
    }
    @IBOutlet weak var multiAddressLabel: UILabel! {
        didSet {
            multiAddressLabel.text = "signature".toMultilingualism()
        }
    }
    @IBOutlet weak var multiAddressStatckView: UIStackView!
    @IBOutlet weak var mutilAddressValueLabel: UILabel! {
        didSet {
            mutilAddressValueLabel.numberOfLines = 1
        }
    }
    @IBOutlet weak var copyAddressButton: UIButton! {
        didSet {
            copyAddressButton.setTitle("", for: .normal)
        }
    }
    private lazy var button1: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    private lazy var button2: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        v.setTitleColor(.white, for: .normal)
        return v
    }()
    
    private lazy var button3: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    private lazy var button4: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
   
    
    @IBOutlet weak var leftStackView: UIStackView! {
        didSet {
            leftStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            leftStackView.setContentHuggingPriority(.required, for: .horizontal)
        }
    }
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var timeBg: UIView! {
        didSet {
            timeBg.layer.cornerRadius = timeBg.width / 2
            timeBg.clipsToBounds = true
            timeBg.isHidden = true
        }
    }
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var timeDesLabel: UILabel! {
        didSet {
            timeDesLabel.text = "等待处理".toMultilingualism()
            timeDesLabel.minimumScaleFactor = 0.5
            timeDesLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var timeIcon: UIImageView!
    
    var timerLabel: MZTimerLabel!
    
    private(set) var model: GuaranteeInfoModel.Meta?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerLabel = MZTimerLabel(label: time, andTimerType: MZTimerLabelType(rawValue: 1))!
        timerLabel.delegate = self
        
        desLabel5Me.snp.remakeConstraints { make in
            make.width.height.equalTo(16)
        }
        desLabel5Me.clipsToBounds = true
        desLabel5Me.layer.cornerRadius = 8
        
        desLabel4Me.snp.remakeConstraints { make in
            make.width.height.equalTo(16)
        }
        desLabel4Me.clipsToBounds = true
        desLabel4Me.layer.cornerRadius = 8
        
        bind()
    
    }
    
    private func bind() {
        button2.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            if self.button2.titleLabel?.text == "申请解押".toMultilingualism() {
                let vc: OrderOperationViewController = ViewLoader.Storyboard.controller(from: "Me")
                vc.state = .applyRelease
                vc.assureId = self.model?.assureId
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
        
        button3.rx.tap.subscribe(onNext: {[unowned self] in
            if self.button3.titleLabel?.text == "撤销申请".toMultilingualism() {
                let vc: OrderOperationViewController = ViewLoader.Storyboard.controller(from: "Me")
                vc.state = .revoke
                vc.assureId = self.model?.assureId
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
            } else if self.button3.titleLabel?.text == "处理解押".toMultilingualism() {
                let vc: OrderOperationViewController = ViewLoader.Storyboard.controller(from: "Me")
                vc.state = .handling
                vc.assureId = self.model?.assureId
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
        
        copyAddressButton.rx.tap.subscribe(onNext: {[weak self] _ in
            var address: String = ""
            if let str = self?.model?.multisigAddress {
                address = str
            }
            UIPasteboard.general.string = address
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        button1.rx.tap.subscribe(onNext: {[unowned self] in
            if self.button1.titleLabel?.text == "联系对方".toMultilingualism() {
                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                vc.orderInfoModel = self.model
                if self.model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                    vc.walletId = self.model?.partnerUser
                } else {
                    vc.walletId = self.model?.sponsorUser
                }
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
            if self.button1.titleLabel?.text == "联系客服".toMultilingualism() {
                let app = UIApplication.shared.delegate as? AppDelegate
                app?.openTg()
            }
            
        }).disposed(by: rx.disposeBag)
        
        button2.rx.tap.subscribe(onNext: {[unowned self] in
            if self.button2.titleLabel?.text == "联系对方".toMultilingualism() {
                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                vc.orderInfoModel = self.model
                if self.model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                    vc.walletId = self.model?.partnerUser
                } else {
                    vc.walletId = self.model?.sponsorUser
                }
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
            
        }).disposed(by: rx.disposeBag)
    }
    
    
    private func isMultiGuarantee(isHidden: Bool) {
        superLinkLabel.isHidden = isHidden
        superLinkValueLabel.isHidden = isHidden
        multiAddressLabel.isHidden = isHidden
        multiAddressStatckView.isHidden = isHidden
    }
    
    private func getSuperLink(pushAddress: String?) -> String {
        if let pushAddress = pushAddress, !pushAddress.isEmpty {
            if LocaleWalletManager.shared().isTronMainNet {
                return "https://nile.tronscan.org/#/address/" + pushAddress
            } else {
                return "https://tronscan.org/#/address/" + pushAddress
            }
        }
        return "--"
    }
    
    func setupData(data: GuaranteeInfoModel.Meta) {
        model = data
        if data.assureType == 0 {
            isMultiGuarantee(isHidden: true)
        } else if data.assureType == 1 {
            superLinkValueLabel.text = getSuperLink(pushAddress: data.pushAddress)
            mutilAddressValueLabel.text = data.multisigAddress ?? ""
            isMultiGuarantee(isHidden: false)
        }
        valueLabel1.text = data.assureId
        valueLabel2.text = Date(timeIntervalSince1970: (data.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        let amount = NSMutableAttributedString(string: "\(data.amount ?? 0) USDT")
        valueLabel3.textColor = ColorConfiguration.lightBlue.toColor()
        amount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel3.attributedText = amount
        valueLabel4.text = data.sponsorUserName ?? "--"
        valueLabel5.text = data.partnerUserName ?? "--"
        valueLabel4sub.text = "\(data.sponsorAmount ?? 0)"
        valueLabel5sub.text = "\(data.partnerAmount ?? 0)"
        
        if data.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            desLabel4Me.isHidden = false
            desLabel5Me.isHidden = true
        } else if data.partnerUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            desLabel4Me.isHidden = true
            desLabel5Me.isHidden = false
        }
        tagLabel.text = data.assureTypeToString()
        let sponsorReleasedAmount = NSMutableAttributedString(string: "\(data.sponsorAmount ?? 0) USDT")
        valueLabel4sub.textColor = ColorConfiguration.lightBlue.toColor()
        sponsorReleasedAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel4sub.attributedText = sponsorReleasedAmount
        
        let partnerReleasedAmount = NSMutableAttributedString(string: "\(data.partnerAmount ?? 0) USDT")
        valueLabel5sub.textColor = ColorConfiguration.lightBlue.toColor()
        partnerReleasedAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel5sub.attributedText = partnerReleasedAmount
        
        if data.assureStatus == 2 { // 担保中
            buttonStackView.isHidden = false
            buttonStackView.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            buttonStackView.addArrangedSubview(button1)
            buttonStackView.addArrangedSubview(button2)
            button1.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            button2.setupAPPUISolidStyle(title: "申请解押".toMultilingualism())
            valueLabel1Status.text = "me_guaranteeing".toMultilingualism()
            
        } else if data.assureStatus == 9 { // 退押中
            buttonStackView.isHidden = false
            buttonStackView.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            buttonStackView.addArrangedSubview(button2)
            button2.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            valueLabel1Status.text = "me_releasing".toMultilingualism()
            valueLabel1Status.textColor = UIColor(hex: "#F0A158")
            valueLabel1Status.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
            
            if data.releaseSponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                buttonStackView.addArrangedSubview(button3)
                button3.setupAPPUISolidStyle(title: "撤销申请".toMultilingualism())
            } else {
                if data.arbitrate == 0 {
                    buttonStackView.addArrangedSubview(button3)
                    button3.setupAPPUISolidStyle(title: "处理解押".toMultilingualism())
                }
            }
            
            if data.releaseStatus == 1 || data.releaseStatus == 3 {
                timeBg.isHidden = false
                timeBg.snp.updateConstraints { make in
                    make.height.width.equalTo(76)
                }
                
                let releaseTimeout = Int(AppArchiveder.shared().getAPPConfig(by: "releaseTimeout") ?? "0") ?? 0
                var createTime = Date(timeIntervalSince1970: (data.multisigTime ?? 0) / 1000 )
                
                let endTime = createTime + releaseTimeout.minutes + 3.seconds
                let countTime = endTime - Date()
                
                if endTime.isInPast {
                    time.text = "已超时".toMultilingualism()
                    time.textColor = UIColor(hex: "#FF5966")
                    buttonStackView.arrangedSubviews.forEach { v in
                        v.removeFromSuperview()
                    }
                    timerLabel?.removeFromSuperview()
                } else {
                    timerLabel?.setCountDownTime(countTime.timeInterval)
                    timerLabel?.start()
                }
                
            } else if data.releaseStatus == 6 {
                timeBg.isHidden = true
                timeBg.snp.updateConstraints { make in
                    make.height.width.equalTo(CGFloat.leastNonzeroMagnitude)
                }
            } else {
                timeBg.isHidden = true
                timeBg.snp.updateConstraints { make in
                    make.height.width.equalTo(CGFloat.leastNonzeroMagnitude)
                }
            }
            
        } else if data.assureStatus == 3 { // 已退押
            buttonStackView.isHidden = false
            buttonStackView.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            buttonStackView.addArrangedSubview(button1)
            buttonStackView.addArrangedSubview(button2)
            button1.setupAPPUIHollowStyle(title: "联系客服".toMultilingualism())
            button2.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
            valueLabel1Status.text = "me_released".toMultilingualism()
            valueLabel1Status.textColor = UIColor(hex: "#999999")
            valueLabel1Status.backgroundColor = UIColor(hex: "#999999").withAlphaComponent(0.1)
        } else if data.assureStatus == 8 { // 已删除, 已取消
            buttonStackView.isHidden = true
            buttonStackView.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            valueLabel1Status.textColor = UIColor(hex: "#FF5966")
            valueLabel1Status.backgroundColor = UIColor(hex: "#FF5966").withAlphaComponent(0.1)
            valueLabel1Status.text = "已取消".toMultilingualism()
        }
    }
    
    @objc
    private func protocolTap() {
        NotiAlterView.show(title: "协议".toMultilingualism(), content: model?.agreement, leftButtonTitle: nil, rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in
            
        }).disposed(by: rx.disposeBag)
    }
    
    @objc private func contactTap() {
        UIPasteboard.general.string = "担保ID".toMultilingualism() + ": " + (model?.assureId ?? "")
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.openTg()
    }
    
    @objc
    private func openLink() {
        let link = getSuperLink(pushAddress: model?.pushAddress)
        if !link.isEmpty, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
}


extension GuaranteeingCell: MZTimerLabelDelegate {
    
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        timerLabel?.removeFromSuperview()
        time.text = "已超时".toMultilingualism()
        time.textColor = UIColor(hex: "#FF5966")
        buttonStackView.arrangedSubviews.forEach { v in
            v.removeFromSuperview()
        }
    }
}
