//
//  ChangeNameController.swift
//  WalletX
//
//  Created by DZSB-001968 on 30.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class ChangeNameController: UIViewController, HomeNavigationble {

    @IBOutlet weak var walletNameLabel: UILabel! {
        didSet {
            walletNameLabel.text = "钱包名称".toMultilingualism()
        }
    }
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "请输入".toMultilingualism()
        }
    }
    var changeWalletModel: WalletModel?
    var didSaveBlock: ((WalletModel?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
  
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "tab_wallet".toMultilingualism()
        headerView?.backgroundColor = .white

        headerView?.stackView.addArrangedSubview(headerView!.shareButton)
        headerView?.shareButton.setImage(nil, for: .normal)
        headerView?.shareButton.setTitle("保存".toMultilingualism(), for: .normal)
        headerView?.shareButton.setTitleColor(ColorConfiguration.blackText.toColor(), for: .normal)
        headerView?.shareButton.rx.tap.subscribe(onNext: {[weak self] _ in
            if let str = self?.textField.text {
                self?.changeWalletModel?.name = str
                self?.didSaveBlock?(self?.changeWalletModel)
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: rx.disposeBag)
    }
    
}
