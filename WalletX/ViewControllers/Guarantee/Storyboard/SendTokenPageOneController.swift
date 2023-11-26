//
//  SendTokenPageOneController.swift
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

class SendTokenPageOneController: UIViewController, HomeNavigationble {
    
    var model: WalletToken?
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.text = "收款地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var textFieldBg: UIView! {
        didSet {
            textFieldBg.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "钱包地址".toMultilingualism()
        }
    }
    
    @IBOutlet weak var pasteButton: UIButton! {
        didSet {
            pasteButton.setTitle("粘贴".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            let img = UIImage(named: "guarantee_scan")?.qmui_image(withTintColor: ColorConfiguration.primary.toColor())
            scanButton.setImage(img, for: .normal)
        }
    }
    
    @IBOutlet weak var desLabel2: UILabel! {
        didSet {
            desLabel2.text = "转账数量".toMultilingualism()
        }
    }
    
    @IBOutlet weak var tokenLabel: UILabel!
    
    @IBOutlet weak var textField2: UITextField! {
        didSet {
            textField2.placeholder = "0.00"
            textField2.keyboardType = .decimalPad
        }
    }
    
    @IBOutlet weak var textFieldBg2: UIView! {
        didSet {
            textFieldBg2.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var allButton: UIButton! {
        didSet {
            allButton.setTitle("全部".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.setupAPPUISolidStyle(title: "确定".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
    
        tokenLabel.text = model?.tokenName
        headerView?.titleLabel.text = model?.companyName
        
        pasteButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.textField.text = UIPasteboard.general.string
        }).disposed(by: rx.disposeBag)
        
        allButton.rx.tap.subscribe(onNext: {[weak self] _ in
            if self?.model == .usdt(nil) {
                self?.textField2.text = LocaleWalletManager.shared().walletBalanceModel?.data?.USDT
            } else {
                self?.textField2.text = LocaleWalletManager.shared().walletBalanceModel?.data?.TRX
            }
        }).disposed(by: rx.disposeBag)
        
        scanButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc = ScanViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            vc.scanCompletion { address in
                self?.textField.text = address
            }
        }).disposed(by: rx.disposeBag)
        
        nextButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            self.sendTokenAction()
        }).disposed(by: rx.disposeBag)
    }
    
    private func sendTokenAction() {
        guard let m = model else { return }
        let toAddress = textField.text ?? ""
        let sendAmount = textField2.text ?? ""
        
        if toAddress.count == 0 {
            APPHUD.flash(text: "请输入钱包收款地址".toMultilingualism())
            return
        }
        
        if sendAmount.count == 0 {
            APPHUD.flash(text: "请输入转账数量".toMultilingualism())
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
                        LocaleWalletManager.shared().sendToken(toAddress: toAddress, amount: Double(sendAmount) ?? 0.0, coinType: m).subscribe(onNext: {[weak self] tuple in
                            APPHUD.hide()
                            if tuple.0 {
                                let vc: SendTokenPageTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
                                vc.model = self?.model
                                vc.toAddress = toAddress
                                vc.txid = tuple.1
                                vc.sendCount = sendAmount
                                self?.navigationController?.pushViewController(vc, animated: true)
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
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
