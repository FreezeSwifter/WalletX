//
//  DepositingDetailController.swift
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


class DepositingDetailController: UIViewController {

    var model: GuaranteeInfoModel.Meta? {
        didSet {
            updateVlaue()
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
            desLabel4Me.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            desLabel4Me.minimumScaleFactor = 0.5
            desLabel4Me.adjustsFontSizeToFitWidth = true
            desLabel4Me.isHidden = true
            desLabel4Me.textAlignment = .center
        }
    }
    
    @IBOutlet weak var desLabel5Me: UILabel! {
        didSet {
            desLabel5Me.text = "我".toMultilingualism()
            desLabel5Me.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            desLabel5Me.minimumScaleFactor = 0.5
            desLabel5Me.adjustsFontSizeToFitWidth = true
            desLabel5Me.isHidden = true
            desLabel5Me.textAlignment = .center
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "参与人".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1Status: UILabel! {
        didSet {
            valueLabel1Status.minimumScaleFactor = 0.5
            valueLabel1Status.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var desLabel8: UILabel! {
        didSet {
            desLabel8.text = "6位小数".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.minimumScaleFactor = 0.5
            valueLabel1.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var valueLabel1Protocol: UILabel! {
        didSet {
            valueLabel1Protocol.text = "协议".toMultilingualism()
            valueLabel1Protocol.minimumScaleFactor = 0.5
            valueLabel1Protocol.adjustsFontSizeToFitWidth = true
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
    
    @IBOutlet weak var notiBg: UIView! {
        didSet {
            notiBg.clipsToBounds = true
            notiBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var notiLabel: UILabel! {
        didSet {
            notiLabel.text = "--"
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = "本次上押".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addrtessField: UITextField! {
        didSet {
            addrtessField.placeholder = nil
        }
    }
    
    @IBOutlet weak var addressCopyButton: UIButton! {
        didSet {
            addressCopyButton.setTitle("全部".toMultilingualism(), for: .normal)
            addressCopyButton.titleLabel?.adjustsFontSizeToFitWidth = true
            addressCopyButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    
    @IBOutlet weak var bottomLeftButton: UIButton! {
        didSet {
            bottomLeftButton.setTitle("站内钱包导入".toMultilingualism(), for: .normal)
            bottomLeftButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            bottomLeftButton.layer.cornerRadius = 10
            bottomLeftButton.backgroundColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var bottomRIghtButton: UIButton! {
        didSet {
            bottomRIghtButton.setTitle("其他钱包转入".toMultilingualism(), for: .normal)
            bottomRIghtButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            bottomRIghtButton.layer.cornerRadius = 10
            bottomRIghtButton.backgroundColor = ColorConfiguration.primary.toColor()
        }
    }
    
    @IBOutlet weak var protocolBg: UIStackView! {
        didSet {
            protocolBg.isLayoutMarginsRelativeArrangement = true
            protocolBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            protocolBg.applyCornerRadius(protocolBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(DepositingDetailController.protocolTap))
            protocolBg.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var serverBg: UIStackView! {
        didSet {
            serverBg.isLayoutMarginsRelativeArrangement = true
            serverBg.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
            serverBg.applyCornerRadius(serverBg.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
            let ges = UITapGestureRecognizer(target: self, action: #selector(DepositingDetailController.serverTap))
            serverBg.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var desLabel6: UILabel! {
        didSet {
            desLabel6.text = "已上押".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel7: UILabel! {
        didSet {
            desLabel7.text = "me_depositing".toMultilingualism()
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
            valueLabel8.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var pushWaitAmountDesLabel: UILabel!
    
    @IBOutlet weak var valueLabel2Status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func updateVlaue() {
        view.layoutIfNeeded()
        valueLabel1.text = model?.assureId ?? "--"
        valueLabel2.text = Date(timeIntervalSince1970: (model?.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        let amount = NSMutableAttributedString(string: "\(model?.amount ?? 0) USDT")
        valueLabel3.textColor = ColorConfiguration.lightBlue.toColor()
        amount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel3.attributedText = amount
        
        let custodyAmount = NSMutableAttributedString(string: "\(model?.custodyAmount ?? 0) USDT")
        valueLabel6.textColor = ColorConfiguration.primary.toColor()
        custodyAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel6.attributedText = custodyAmount
        
        let sponsorAmount = NSMutableAttributedString(string: "\(model?.sponsorAmount ?? 0) USDT")
        valueLabel7.textColor = ColorConfiguration.primary.toColor()
        sponsorAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel7.attributedText = sponsorAmount
        
        let partnerAmount = NSMutableAttributedString(string: "\(model?.partnerAmount ?? 0) USDT")
        valueLabel8.textColor = ColorConfiguration.primary.toColor()
        partnerAmount.color(ColorConfiguration.blackText.toColor(), occurences: "USDT")
        valueLabel8.attributedText = partnerAmount
        
        valueLabel4.text = model?.sponsorUserName ?? "--"
        valueLabel5.text = model?.partnerUserName ?? "--"
        
        if model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            desLabel4Me.isHidden = false
            desLabel5Me.isHidden = true
            valueLabel8.text = model?.pushDecimalSponsor
        } else {
            desLabel4Me.isHidden = true
            desLabel5Me.isHidden = false
        }
        if model?.assureType == 0 { // 普通
            valueLabel1Status.text = "普通担保".toMultilingualism()
            notiLabel.text = "上押小喇叭普通".toMultilingualism()
        } else {
            valueLabel1Status.text = "多签担保".toMultilingualism()
            notiLabel.text = "上押小喇叭多签".toMultilingualism()
        }
        valueLabel2Status.text = "待上押".toMultilingualism()
        pushWaitAmountDesLabel.text = "\(model?.pushWaitAmount ?? 0)"
        addrtessField.text = "\(model?.pushWaitAmount ?? 0)"
    }
    
    private func bind() {
        
        let req: Observable<GuaranteeInfoModel?> = APIProvider.rx.request(.getAssureOrderDetail(assureId: model?.assureId ?? "")).mapModel()
        req.subscribe(onNext: {[weak self] obj in
            self?.model = obj?.data
        }).disposed(by: rx.disposeBag)
        
        bottomRIghtButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            
            let vc: OtherWalletSendController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = model
            var isInitiator: Bool
            if model?.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
                isInitiator = true
            } else {
                isInitiator = false
            }
            vc.payType = .deposited(isInitiator: isInitiator)
            navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        bottomLeftButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let vc: SendTokenPageTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
            vc.model = LocaleWalletManager.shared().USDT
            vc.toAddress = model?.pushAddress
            vc.toAddress = model?.multisigAddress
            vc.sendCount = addrtessField.text
            vc.defaultMaxTotal = "20"
            vc.defaultNetworkFee = "10"
            vc.sendType = .business(from: 1, assureId: model?.assureId ?? "")
            navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: rx.disposeBag)
        
        addressCopyButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.addrtessField.text = "\(self?.model?.pushWaitAmount ?? 0)"
        }).disposed(by: rx.disposeBag)
    }
 
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        title = "上传押金".toMultilingualism()
        view.layoutIfNeeded()
        
        desLabel4Me.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        desLabel5Me.snp.makeConstraints { make in
            make.height.width.equalTo(20)
        }
        desLabel4Me.applyCornerRadius(10)
        desLabel5Me.applyCornerRadius(10)
    }
    
    @objc
    private func protocolTap() {
        NotiAlterView.show(title: "协议".toMultilingualism(), content: model?.agreement, leftButtonTitle: nil, rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in
            
        }).disposed(by: rx.disposeBag)
    }
    
    @objc
    private func serverTap() {
        let app = UIApplication.shared.delegate as? AppDelegate
        app?.openTg()
    }
}
