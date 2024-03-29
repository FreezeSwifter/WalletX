//
//  MeTobeAddedCell.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import UIKit
import QMUIKit
import SwiftDate
import MZTimerLabel
import RxCocoa
import RxSwift
import NSObject_Rx

class MeTobeAddedCell: UITableViewCell {
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var concat: UIStackView! {
        didSet {
            concat.isLayoutMarginsRelativeArrangement = true
            concat.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            concat.applyCornerRadius(concat.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(MeTobeAddedCell.contactTap))
            concat.addGestureRecognizer(ges)
        }
    }
    @IBOutlet weak var serviceLabel: UILabel! {
        didSet {
            serviceLabel.text = "客服".toMultilingualism()
        }
    }
    @IBOutlet weak var guaranteeIdDesLabel: UILabel! {
        didSet {
            guaranteeIdDesLabel.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var timeDesLabel: UILabel! {
        didSet {
            timeDesLabel.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var moneyDesLabel: UILabel! {
        didSet {
            moneyDesLabel.text = "担保金额没有1".toMultilingualism()
        }
    }
    
    @IBOutlet weak var creatorDesLabel: UILabel! {
        didSet {
            creatorDesLabel.text = "发起人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var meDes2Label: QMUILabel! {
        didSet {
            meDes2Label.text = "我".toMultilingualism()
            meDes2Label.isHidden = true
        }
    }
    
    @IBOutlet weak var meDesLabel: QMUILabel! {
        didSet {
            meDesLabel.text = "我".toMultilingualism()
            meDesLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var meIdDesLabel2: UILabel! {
        didSet {
            meIdDesLabel2.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var idValueLabel: UILabel! {
        didSet {
            idValueLabel.minimumScaleFactor = 0.5
            idValueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var timeValueLabel: UILabel! {
        didSet {
            timeValueLabel.minimumScaleFactor = 0.5
            timeValueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var moneyValueLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(MeTobeAddedCell.moneyLabelTap))
            moneyValueLabel.addGestureRecognizer(gesture)
            moneyValueLabel.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var creatorValueLabel: UILabel! {
        didSet {
            creatorValueLabel.minimumScaleFactor = 0.5
            creatorValueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    @IBOutlet weak var meValueLabel: UILabel! {
        didSet {
            meValueLabel.minimumScaleFactor = 0.5
            meValueLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var stateLabel: QMUILabel! {
        didSet {
            stateLabel.minimumScaleFactor = 0.5
            stateLabel.adjustsFontSizeToFitWidth = true
            stateLabel.contentEdgeInsets = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
            stateLabel.applyCornerRadius(8)
        }
    }
    
    @IBOutlet weak var topContractBg: UIStackView! {
        didSet {
            topContractBg.isLayoutMarginsRelativeArrangement = true
            topContractBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            topContractBg.applyCornerRadius(topContractBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(MeTobeAddedCell.protocolTap))
            topContractBg.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var topContractDesLabel: UILabel! {
        didSet {
            topContractDesLabel.text = "协议".toMultilingualism()
        }
    }
    
    @IBOutlet weak var timeBg: UIView! {
        didSet {
            timeBg.layer.cornerRadius = timeBg.width / 2
            timeBg.clipsToBounds =  true
        }
    }
    
    @IBOutlet weak var timeIcon: UIImageView!
    
    @IBOutlet weak var waitingDesLabel: UILabel! {
        didSet {
            waitingDesLabel.text = "--"
            waitingDesLabel.minimumScaleFactor = 0.5
            waitingDesLabel.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var time: UILabel! {
        didSet {
            time.text = "aaaa"//"等待加入中".toMultilingualism()
            time.minimumScaleFactor = 0.5
            time.adjustsFontSizeToFitWidth = true
        }
    }
    
    private lazy var contactButton: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    private lazy var cancelButton: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    private lazy var modifyButton: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    private lazy var inviteButton: UIButton = {
        let v = UIButton(type: .custom)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return v
    }()
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var pendedLabel: UILabel! {
        didSet {
            pendedLabel.text = "me_deposited".toMultilingualism()
        }
    }
    @IBOutlet weak var pendingLabel: UILabel! {
        didSet {
            pendingLabel.text = "me_depositing".toMultilingualism()
        }
    }
    @IBOutlet weak var pendedValueLabel: UILabel!
    @IBOutlet weak var pendingValueLabel: UILabel!
    var timerLabel: MZTimerLabel!
    
    private(set) var model: GuaranteeInfoModel.Meta?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timerLabel = MZTimerLabel(label: time, andTimerType: MZTimerLabelType(rawValue: 1))!
        timerLabel.timeFormat = "mm:ss"
        timerLabel.delegate = self
        
        meDesLabel.snp.remakeConstraints { make in
            make.width.height.equalTo(16)
        }
        meDesLabel.applyCornerRadius(8)
        
        meDes2Label.snp.remakeConstraints { make in
            make.width.height.equalTo(16)
        }
        meDes2Label.applyCornerRadius(8)
        
        bind()
        
        pendedValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pendedValueLabel.centerYAnchor.constraint(equalTo: pendedLabel.centerYAnchor)
        ])
        
        pendingValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pendingValueLabel.centerYAnchor.constraint(equalTo: pendingLabel.centerYAnchor)
        ])
    }
    
    
    private func bind() {
        contactButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
            vc.orderInfoModel = self?.model
            if self?.model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                vc.walletId = self?.model?.partnerUser
            } else {
                vc.walletId = self?.model?.sponsorUser
            }
    
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "me_cancel_alter_img"), title: "取消担保弹窗标题".toMultilingualism(), titleIcon: nil, content: "取消担保弹窗内容".toMultilingualism(), leftButton: "立即取消".toMultilingualism(), rightButton: "稍后再说".toMultilingualism()).subscribe(onNext: {[weak self] index in
                guard let this = self, let id = this.model?.assureId else { return }
                if index == 0 {
                    APIProvider.rx.request(.cancelGuarantee(assureId: id)).mapJSON().subscribe(onSuccess: { _ in
                        APPHUD.flash(text: "成功".toMultilingualism())
                        NotificationCenter.default.post(name: .orderDidChangeed, object: nil)
                    }).disposed(by: this.rx.disposeBag)
                }
            }).disposed(by: self.rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        
        modifyButton.rx.tap.subscribe(onNext: {[unowned self] in
            if modifyButton.titleLabel?.text == "我来上押".toMultilingualism() {
                self.depositTap()
            } else if modifyButton.titleLabel?.text == "付手续费".toMultilingualism() {
                self.payAssureFee()
            }
        }).disposed(by: rx.disposeBag)
        
        
        inviteButton.rx.tap.subscribe(onNext: {[weak self] in
            let vc: InviteGuaranteeController = ViewLoader.Storyboard.controller(from: "Guarantee")
            vc.model = self?.model
            vc.hidesBottomBarWhenPushed = true
            UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
    
    @objc
    private func moneyLabelTap() {
        
        ChangeMoneyAlterVIew.show().subscribe(onNext: {[weak self] index in
            
            if index == 0 {
                let vc: ContactOtherController = ViewLoader.Storyboard.controller(from: "Me")
                if self?.model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                    vc.walletId = self?.model?.partnerUser
                } else {
                    vc.walletId = self?.model?.sponsorUser
                }
                vc.orderInfoModel = self?.model
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }
    
    private func appendUSDT(text: String) -> NSAttributedString {
        let amountStr = NSMutableAttributedString(string: text, attributes: [.foregroundColor: ColorConfiguration.primary.toColor()])
        let unitStr = NSAttributedString(string: " USDT", attributes: [.foregroundColor: ColorConfiguration.blackText.toColor()])
        amountStr.append(unitStr)
        return amountStr
    }
    
    private func isDepositingStatus(isHidden: Bool) {
        pendedLabel.isHidden = isHidden
        pendingLabel.isHidden = isHidden
        pendedValueLabel.isHidden = isHidden
        pendingValueLabel.isHidden = isHidden
    }
    
    func setupData(data: GuaranteeInfoModel.Meta) {
        model = data
        isDepositingStatus(isHidden: true)
        idValueLabel.text = data.assureId ?? "--"
        timeValueLabel.text = Date(timeIntervalSince1970: (data.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        creatorValueLabel.text = data.sponsorUserName ?? "--"
        let amount = NSMutableAttributedString(string: "\(data.amount ?? 0) USDT")
        moneyValueLabel.textColor = ColorConfiguration.lightBlue.toColor()
        amount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        moneyValueLabel.attributedText = amount
        meValueLabel.text = data.partnerUserName ?? "--"
        pendedValueLabel.attributedText = appendUSDT(text: "\(data.custodyAmount ?? 0.00)")
        pendingValueLabel.attributedText = appendUSDT(text: "\(data.pushWaitAmount ?? 0.00)")
        if data.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            meDes2Label.isHidden = false
            meDesLabel.isHidden = true
        } else {
            meDes2Label.isHidden = true
            meDesLabel.isHidden = false
        }
        tagLabel.text = data.assureTypeToString()
        if data.assureStatus == 0 || data.assureStatus == 5 { // 待加入
            stateLabel.backgroundColor = UIColor(hex: "#40BCFC").withAlphaComponent(0.1)
            stateLabel.textColor = UIColor(hex: "#40BCFC")
            stateLabel.text = "me_pending".toMultilingualism()
            if data.assureStatus == 5 { // 待加入超时
                buttonStackView.isHidden = true
                timeIcon.image = UIImage(named: "me_overtime")
                time.textColor = UIColor(hex: "#FF5966")
                time.text = "已超时".toMultilingualism()
                waitingDesLabel.text = "等待加入中".toMultilingualism()
                buttonStackView.arrangedSubviews.forEach { v in
                    v.removeFromSuperview()
                }
                timerLabel?.removeFromSuperview()
            } else {
                timeIcon.image = UIImage(named: "me_time")
                time.textColor = ColorConfiguration.descriptionText.toColor()
                time.text = "me_pending".toMultilingualism()
                waitingDesLabel.text = "等待加入中".toMultilingualism()
                buttonStackView.isHidden = false
                let createTime = Date(timeIntervalSince1970: (data.createTime ?? 0) / 1000 )
                let timeout = Int(AppArchiveder.shared().getAPPConfig(by: "joinTimeout") ?? "0") ?? 0
                let endTime = createTime + timeout.minutes + 3.seconds
                let countTime = endTime - Date()
                timerLabel?.setCountDownTime(countTime.timeInterval)
                timerLabel?.start()
                
                buttonStackView.arrangedSubviews.forEach { v in
                    v.removeFromSuperview()
                }
                buttonStackView.addArrangedSubview(cancelButton)
                buttonStackView.addArrangedSubview(inviteButton)
                cancelButton.setupAPPUIHollowStyle(title: "取消担保".toMultilingualism())
                inviteButton.setupAPPUISolidStyle(title: "邀请对方".toMultilingualism())
            }
            
        }  else if data.assureStatus == 1 || data.assureStatus == 6 || data.assureStatus == 7 { // 待上押
            isDepositingStatus(isHidden: false)
            if data.assureStatus == 6 { // 创建钱包已超时
                buttonStackView.isHidden = true
                stateLabel.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
                stateLabel.textColor = UIColor(hex: "#F0A158")
                stateLabel.text = "me_depositing".toMultilingualism()
                timeIcon.image = UIImage(named: "me_overtime")
                time.textColor = UIColor(hex: "#FF5966")
                time.text = "已超时".toMultilingualism()
                waitingDesLabel.text = "钱包创建中".toMultilingualism()
                buttonStackView.arrangedSubviews.forEach { v in
                    v.removeFromSuperview()
                }
                timerLabel?.removeFromSuperview()
                
            } else if data.assureStatus == 7 { // 多签已超时
                buttonStackView.isHidden = true
                stateLabel.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
                stateLabel.textColor = UIColor(hex: "#F0A158")
                stateLabel.text = "me_depositing".toMultilingualism()
                timeIcon.image = UIImage(named: "me_overtime")
                time.textColor = UIColor(hex: "#FF5966")
                time.text = "已超时".toMultilingualism()
                waitingDesLabel.text = "等待上押中".toMultilingualism()
                buttonStackView.arrangedSubviews.forEach { v in
                    v.removeFromSuperview()
                }
                timerLabel?.removeFromSuperview()
                
            } else {
                
                stateLabel.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
                waitingDesLabel.text = "me_depositing".toMultilingualism()
                stateLabel.textColor = UIColor(hex: "#F0A158")
                stateLabel.text = "me_depositing".toMultilingualism()
                timeIcon.image = UIImage(named: "me_time")
                time.textColor = ColorConfiguration.descriptionText.toColor()
                buttonStackView.isHidden = false
                buttonStackView.arrangedSubviews.forEach { v in
                    v.removeFromSuperview()
                }
                buttonStackView.addArrangedSubview(contactButton)
                buttonStackView.addArrangedSubview(modifyButton)
                if data.assureType == 1 && data.hcPay == 0 {
                    modifyButton.setupAPPUISolidStyle(title: "付手续费".toMultilingualism())
                } else {
                    modifyButton.setupAPPUISolidStyle(title: "我来上押".toMultilingualism())
                }
                contactButton.setupAPPUIHollowStyle(title: "联系对方".toMultilingualism())
                
                var createTime: Date
                var timeout: Int
                if data.assureType == 0  { // 普通担保
                    createTime = Date(timeIntervalSince1970: (data.multisigTime ?? 0) / 1000 )
                    timeout = Int(AppArchiveder.shared().getAPPConfig(by: "pushTimeout") ?? "0") ?? 0
                    waitingDesLabel.text = "等待上押中".toMultilingualism()
                } else { // 多签担保
                    createTime = Date(timeIntervalSince1970: (data.multisigTime ?? 0) / 1000 )
                    if data.multisigStatus == 0 { // 多签钱包创建中
                        timeout = Int(AppArchiveder.shared().getAPPConfig(by: "multisigTimeout") ?? "0") ?? 0
                        waitingDesLabel.text = "等待上押中".toMultilingualism()
                    } else {
                        timeout = Int(AppArchiveder.shared().getAPPConfig(by: "pushTimeout") ?? "0") ?? 0
                        waitingDesLabel.text = "创建钱包中".toMultilingualism()
                    }
                }
                
                let endTime = createTime + timeout.minutes + 3.seconds
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
            }
            
        } else if data.assureStatus == 4 { // 已取消
            buttonStackView.isHidden = true
            stateLabel.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
            stateLabel.textColor = UIColor(hex: "#F0A158")
            stateLabel.text = "交易取消".toMultilingualism()
            timeIcon.image = UIImage(named: "me_overtime")
            time.textColor = UIColor(hex: "#FF5966")
            waitingDesLabel.text = "交易已取消".toMultilingualism()
            buttonStackView.arrangedSubviews.forEach { v in
                v.removeFromSuperview()
            }
            timerLabel?.removeFromSuperview()
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
    
    private func depositTap() {
    
        guard let id = model?.assureId else { return }
        let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.getAssureOrderDetail(assureId: id)).mapModel()
        
        req.subscribe(onNext: {[weak self] obj in
            guard let this = self else { return }
            if obj?.data?.multisigStatus == 0 && obj?.data?.assureType == 1 {
                let time = obj?.data?.multisigTime ?? 0
                DepositingAlterView.show(time: time).subscribe(onNext: { index in
                    
                }).disposed(by: this.rx.disposeBag)

            } else {
                
                let vc: DepositingDetailController = ViewLoader.Storyboard.controller(from: "Me")
                vc.model = self?.model
                vc.hidesBottomBarWhenPushed = true
                UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }
    
    /// 付多钱手续费
    private func payAssureFee() {
        let vc = PayHandlingFeeViewController()
        vc.model = model
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}


extension MeTobeAddedCell: MZTimerLabelDelegate {
    
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        timerLabel?.removeFromSuperview()
        time.text = "已超时".toMultilingualism()
        time.textColor = UIColor(hex: "#FF5966")
        stateLabel.textColor = UIColor(hex: "#FF5966")
        stateLabel.text = "已超时".toMultilingualism()
    }
}
