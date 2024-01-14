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
    
    @IBOutlet weak var textField: UITextField!
    
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
    
    @IBOutlet weak var tokenLabel: UILabel! {
        didSet {
            tokenLabel.textColor = ColorConfiguration.descriptionText.toColor()
        }
    }
    
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
            nextButton.setupAPPUISolidStyle(title: "下一步".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
    
        tokenLabel.text = model?.tokenName
        headerView?.titleLabel.text = "\("wallet_send".toMultilingualism())\(model?.contractName ?? "")"
        
        textField.placeholder = "\(model?.contractName ?? "")\("地址".toMultilingualism())"
        
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
        guard let _ = model else { return }
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
        
        let vc: SendTokenPageTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
        vc.model = model
        vc.toAddress = toAddress
        vc.sendCount = sendAmount
        vc.defaultMaxTotal = "20"
        vc.defaultNetworkFee = "10"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
    }
}
