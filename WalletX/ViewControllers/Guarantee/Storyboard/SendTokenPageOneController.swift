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
    
    @IBOutlet weak var tokenLabel: UILabel! {
        didSet {
        }
    }
    
    @IBOutlet weak var textField2: UITextField! {
        didSet {
            textField2.placeholder = "0.00"
            textField2.keyboardType = .numberPad
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
  
        nextButton.rx.tap.subscribe(onNext: {[weak self] _ in
            let vc: SendTokenPageTwoController = ViewLoader.Storyboard.controller(from: "Wallet")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "Token Name".toMultilingualism()
        headerView?.backgroundColor = .white
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
    }
}
