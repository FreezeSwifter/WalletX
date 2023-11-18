//
//  DepositViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 24.9.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import Action
import SwiftData

class DepositViewController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var DesLabel1: UILabel! {
        didSet {
            DesLabel1.text = "待上押担保".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UITextField! {
        didSet {
            valueLabel1.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var valueControl1: UIControl! {
        didSet {
            valueControl1.addTarget(self, action: #selector(DepositViewController.controlTap), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "担保ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desTagLabel2: QMUILabel! {
        didSet {
            desTagLabel2.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
            desTagLabel2.backgroundColor = UIColor(hex: "#F0A1581A").withAlphaComponent(0.1)
            desTagLabel2.applyCornerRadius(desTagLabel2.bounds.height / 2)
            desTagLabel2.text = "me_depositing".toMultilingualism()
            desTagLabel2.textColor = UIColor(hex: "#F0A158")
            desTagLabel2.backgroundColor = UIColor(hex: "#F0A158").withAlphaComponent(0.1)
            desTagLabel2.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    @IBOutlet weak var desTagContainer3: UIStackView! {
        didSet {
            desTagContainer3.isLayoutMarginsRelativeArrangement = true
            desTagContainer3.layoutMargins = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
            desTagContainer3.applyCornerRadius(desTagContainer3.height / 2, maskedCorners: [.layerMinXMinYCorner, .layerMinXMaxYCorner])
        }
    }
    
    @IBOutlet weak var desTagLabel3: UILabel! {
        didSet {
            desTagLabel3.text = "协议".toMultilingualism()
            desTagLabel3.isUserInteractionEnabled = true
            let ges = UITapGestureRecognizer(target: self, action: #selector(DepositViewController.protocolTap))
            desTagLabel3.addGestureRecognizer(ges)
        }
    }
    
    @IBOutlet weak var valeLabel2: UITextField! {
        didSet {
            valeLabel2.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "发起时间".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel3: UITextField! {
        didSet {
            valueLabel3.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "请输入担保金额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel4: UITextField! {
        didSet {
            valueLabel4.isUserInteractionEnabled = true
            valueLabel4.textColor = ColorConfiguration.lightBlue.toColor()
            valueLabel4.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "钱包余额".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel5Sub2: UITextField! {
        didSet {
            valueLabel5Sub2.isUserInteractionEnabled = false
            valueLabel5Sub2.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var valueLabel5Sub1: UITextField! {
        didSet {
            valueLabel5Sub1.isUserInteractionEnabled = false
            valueLabel5Sub1.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    
    @IBOutlet weak var waringStackView: UIStackView! {
        didSet {
            waringStackView.isLayoutMarginsRelativeArrangement = true
            waringStackView.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        }
    }
    
    @IBOutlet weak var waringLabel: UILabel! {
        didSet {
            let text = LanguageManager.shared().replaceBraces(inString: "上押温馨提示".toMultilingualism(), with: LocaleWalletManager.shared().walletBalanceModel?.data?.TRX ?? "--")
            waringLabel.text = text
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setupAPPUISolidStyle(title: "上传押金".toMultilingualism())
        }
    }
    
    @IBOutlet weak var sixBgView: UIView!
    
    @IBOutlet weak var sixDesLabel: UILabel! {
        didSet {
            sixDesLabel.text = "6位小数".toMultilingualism()
        }
    }
    
    @IBOutlet weak var sixTextField: UITextField! {
        didSet {
            sixTextField.isUserInteractionEnabled = false
            sixTextField.textColor = ColorConfiguration.lightBlue.toColor()
            sixTextField.keyboardType = .numberPad
        }
    }
    
    @IBOutlet weak var sixNitoLabel: UILabel! {
        didSet {
            sixNitoLabel.numberOfLines = 2
            sixNitoLabel.adjustsFontSizeToFitWidth = true
            sixNitoLabel.minimumScaleFactor = 0.5
            sixNitoLabel.text = "6位小数提醒".toMultilingualism()
        }
    }
    
    @IBOutlet weak var sixNnotiStack: UIStackView! {
        didSet {
            sixNnotiStack.isLayoutMarginsRelativeArrangement = true
            sixNnotiStack.layoutMargins = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        }
    }
    
    @IBOutlet weak var addressDesLabel: UILabel! {
        didSet {
            addressDesLabel.text = "收款地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var addressTextField: UITextField! {
        didSet {
            addressTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var copyAddressButton: UIButton! {
        didSet {
            copyAddressButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
            copyAddressButton.titleLabel?.adjustsFontSizeToFitWidth = true
            copyAddressButton.titleLabel?.minimumScaleFactor = 0.5
        }
    }
    
    var currentItem: GuaranteeInfoModel.Meta? {
        didSet {
            updateData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
        fetchFirstAssure()
    }
    
    private func updateData() {
        view.layoutIfNeeded()
        guard let item = currentItem else { return }
        valueLabel1.text = "\(item.assureId ?? ""), \(item.pushWaitAmount ?? 0.0)"
        valeLabel2.text = item.assureId
        valueLabel3.text = Date(timeIntervalSince1970: (item.createTime ?? 0) / 1000 ).toFormat("yyyy-MM-dd HH:mm:ss")
        valueLabel4.text = "\(item.amount ?? 0.0)"
        
        if item.sponsorUser == LocaleWalletManager.shared().userInfo?.data?.walletId {
            sixTextField.text = item.pushDecimalSponsor
        } else {
            sixTextField.text = item.pushDecimalPartner
        }
        
        addressTextField.text = item.pushAddress
        
    }
    
    private func bind() {
        LocaleWalletManager.shared().walletBalance.subscribe(onNext: {[weak self] obj in
            self?.valueLabel5Sub1.text = "\(obj?.data?.TRX ?? "--")"
            self?.valueLabel5Sub2.text = "\(obj?.data?.USDT ?? "--")"
        }).disposed(by: rx.disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: {[unowned self] in
            
            if self.sixTextField.text?.count == 6 {
                
                let addressValidateReq = APIProvider.rx.request(.addressValidate(address: self.currentItem?.pushAddress ?? "")).mapJSON()
            
                addressValidateReq.subscribe(onSuccess: {[weak self] obj in
                    
                    guard let this = self, let dict = obj as? [String: Any], let data = dict["data"] as? Bool else { return }
                    if data {
                        
                        let address = this.currentItem?.pushAddress ?? ""
                        let amount = Double(this.valueLabel4.text ?? "") ?? 0.0
                        
                        APPHUD.showLoading(text: "处理中".toMultilingualism())
                        LocaleWalletManager.shared().sendToken(toAddress: address, amount: Double(amount), coinType: .usdt(nil)).subscribe(onNext: {[weak self] tuple in
                            guard let this3 = self else { return }
                            if !tuple.0 {
                                APPHUD.flash(text: "链上转账失败".toMultilingualism())
                                return
                            }
                            APPHUD.hide()
                            let vc: TokenTransferDetailController = ViewLoader.Storyboard.controller(from: "Wallet")
                            var m = TokenTecordTransferModel()
                            m.amount = Double(amount)
                            m.assetName = "USDT"
                            m.from = LocaleWalletManager.shared().USDT?.address
                            m.to = address
                            m.txid = tuple.1
                            vc.model = m
                            this3.navigationController?.pushViewController(vc, animated: true)
                            
                        }).disposed(by: this.rx.disposeBag)
                    }
                }).disposed(by: self.rx.disposeBag)
            } else {
                APPHUD.flash(text: "正确6为小数".toMultilingualism())
            }
        }).disposed(by: rx.disposeBag)
        
        copyAddressButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.addressTextField.text
            APPHUD.flash(text: "完成".toMultilingualism())
        }).disposed(by: rx.disposeBag)
    }

    @objc
    private func protocolTap() {
        NotiAlterView.show(title: "协议".toMultilingualism(), content: currentItem?.agreement, leftButtonTitle: nil, rightButtonTitle: "我知道啦".toMultilingualism()).subscribe(onNext: { _ in
            
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        title = "wallet_deposit".toMultilingualism()
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    @objc
    private func controlTap() {
        let popContainer = QMUIPopupContainerView()
        let contentView = PendingPledgeListView(frame: CGRect(x: 0, y: 0, width: valueControl1.bounds.size.width, height: 400))
        contentView.setupDidSelectedItem {[weak self] item in
            self?.currentItem = item
            popContainer.hideWith(animated: true)
        }
        
        popContainer.contentView.addSubview(contentView)
        popContainer.automaticallyHidesWhenUserTap = true;
        popContainer.contentViewSizeThatFitsBlock = {[weak self] _ -> CGSize in
            guard let this = self else {
                return .zero
            }
            return CGSize(width: this.valueControl1.bounds.width, height: 400)
        }
        popContainer.arrowSize = CGSize.zero
        popContainer.preferLayoutDirection = QMUIPopupContainerViewLayoutDirection.below
        popContainer.sourceView = valueControl1
        popContainer.showWith(animated: true)
    }
    
    private func fetchFirstAssure() {
        let req: Observable<[GuaranteeInfoModel.Meta]> = APIProvider.rx.request(.queryAssureOrderList(assureStatus: 1, pageNum: 1)).mapModelArray()
        req.subscribe(onNext: {[weak self] list in
            self?.currentItem = list.first
        }).disposed(by: rx.disposeBag)
    }
}
