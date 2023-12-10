//
//  SendTokenPageTwoController.swift
//  WalletX
//
//  Created by DZSB-001968 on 31.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

extension SendTokenPageTwoController {
    
    enum SendType {
        case normal
        case business(from: Int, assureId: String)
    }
}


class SendTokenPageTwoController: UIViewController, HomeNavigationble {

    var sendType: SendType = .normal
    var model: WalletToken?
    var toAddress: String?
    var sendCount: String?
    var defaultNetworkFee: String?
    var defaultMaxTotal: String?
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.text = "--"
        }
    }
    
    @IBOutlet weak var topSubLabel: UILabel! {
        didSet {
            topSubLabel.text = "--"
            topSubLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var desBg1: UIStackView! {
        didSet {
            desBg1.isLayoutMarginsRelativeArrangement = true
            desBg1.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg2: UIStackView! {
        didSet {
            desBg2.isLayoutMarginsRelativeArrangement = true
            desBg2.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg3: UIStackView! {
        didSet {
            desBg3.isLayoutMarginsRelativeArrangement = true
            desBg3.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg4: UIStackView! {
        didSet {
            desBg4.isLayoutMarginsRelativeArrangement = true
            desBg4.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var desBg5: UIStackView! {
        didSet {
            desBg5.isLayoutMarginsRelativeArrangement = true
            desBg5.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    }
    
    @IBOutlet weak var sectionBg1: UIStackView! {
        didSet {
            sectionBg1.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var sectionBg2: UIStackView! {
        didSet {
            sectionBg2.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "资产".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "From"
        }
    }
    
    @IBOutlet weak var desLabel3: UILabel! {
        didSet {
            desLabel3.text = "To"
        }
    }
    
    @IBOutlet weak var desLabel4: UILabel! {
        didSet {
            desLabel4.text = "网络费用".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel5: UILabel! {
        didSet {
            desLabel5.text = "最大总计".toMultilingualism()
        }
    }
    
    @IBOutlet weak var valueLabel1: UILabel! {
        didSet {
            valueLabel1.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel2: UILabel! {
        didSet {
            valueLabel2.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel3: UILabel! {
        didSet {
            valueLabel3.text = "--"
        }
    }
    
    @IBOutlet weak var valueLabel4: UILabel! {
        didSet {
            valueLabel4.text = "--"
            valueLabel4.adjustsFontSizeToFitWidth = true
            valueLabel4.minimumScaleFactor = 0.8
        }
    }
    
    @IBOutlet weak var valueLabel5: UILabel! {
        didSet {
            valueLabel5.textColor = ColorConfiguration.lightBlue.toColor()
        }
    }
    
    @IBOutlet weak var bottomButton: UIButton! {
        didSet {
            bottomButton.setupAPPUISolidStyle(title: "确定".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        headerView?.titleLabel.text = model?.companyName
        valueLabel1.text = model?.companyName
        valueLabel2.text = LocaleWalletManager.shared().TRON?.address
        valueLabel3.text = toAddress
        topLabel.text = "\(sendCount ?? "--") \(model?.tokenName ?? "")"

        bottomButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            sendTokenWithFaceId()
        }).disposed(by: rx.disposeBag)
        
        
        if let fee = defaultNetworkFee {
            valueLabel4.text = "\(fee) TRX"
        }
        if let maxTotal = defaultMaxTotal {
            valueLabel5.text = "\(maxTotal) TRX"
        }
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
    }
    
    private func sendTokenWithFaceId() {
        
        guard let toAddress = toAddress else {
            return
        }
        
        guard let sendAmount = sendCount else {
            return
        }
        
        guard let coinType = model else {
            return
        }

        let faceIdVC: FaceIDViewController = ViewLoader.Xib.controller()
        faceIdVC.modalPresentationStyle = .fullScreen
        present(faceIdVC, animated: true)
        
        faceIdVC.resultBlock = {[unowned self] isPass in
            if isPass {
                APPHUD.showLoading(text: "处理中".toMultilingualism())
                let addressValidateReq = APIProvider.rx.request(.addressValidate(address: toAddress)).mapJSON()
                addressValidateReq.subscribe { [unowned self] obj in
                    guard let dict = obj as? [String: Any], let data = dict["data"] as? Bool else {
                        APPHUD.showLoading(text: "链上转账失败".toMultilingualism())
                        return
                    }
                    if data {
                        LocaleWalletManager.shared().sendToken(toAddress: toAddress, amount: Double(sendAmount) ?? 0.0, coinType: coinType).subscribe(onNext: {[weak self] tuple in
                            APPHUD.hide()
                            if tuple.0 {
                                switch self?.sendType {
                                case .normal:
                                    let vc: TokenTransferDetailController = ViewLoader.Storyboard.controller(from: "Wallet")
                                    vc.txid = tuple.1
                                    vc.item = self?.model
                                    vc.toAddress = toAddress
                                    vc.sendAmount = sendAmount
                                    self?.navigationController?.pushViewController(vc, animated: true)
                                case .business(let from, let assureId):
                                    self?.uploadBusinessConfirm(assureId: assureId, from: from, txId: tuple.1, amount: sendAmount, toAddress: toAddress)
                                case .none:
                                    break
                                }
                            } else {
                                APPHUD.showLoading(text: "链上转账失败".toMultilingualism())
                            }
                        }).disposed(by: self.rx.disposeBag)
                        
                    } else {
                        APPHUD.showLoading(text: "处理中".toMultilingualism())
                    }
                } onFailure: { error in
                    APPHUD.showLoading(text: "链上转账失败".toMultilingualism())
                }.disposed(by: rx.disposeBag)
            }
        }
    }
    
    
    private func uploadBusinessConfirm(assureId: String, from: Int, txId: String, amount: String, toAddress: String) {
        APIProvider.rx.request(.seendTokenConfirm(assureId: assureId, function: from, txId: txId, amount: amount))
            .mapJSON().subscribe(onSuccess: { [unowned self] obj in
                let dict = obj as? [String: Any]
                if let code = dict?["code"] as? Int, code == 0 {
                    let vc: TokenTransferDetailController = ViewLoader.Storyboard.controller(from: "Wallet")
                    vc.txid = txId
                    vc.item = model
                    vc.toAddress = toAddress
                    vc.sendAmount = amount
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let msg = dict?["message"] as? String
                    APPHUD.flash(text: msg)
                }
            }).disposed(by: rx.disposeBag)
    }
}
