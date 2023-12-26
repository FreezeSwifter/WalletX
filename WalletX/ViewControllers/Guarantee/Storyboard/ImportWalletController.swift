//
//  ImportWalletController.swift
//  WalletX
//
//  Created by DZSB-001968 on 1.9.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx
import Action


class ImportWalletController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var mnemonicLabel: UILabel! {
        didSet {
            mnemonicLabel.text = "助记词".toMultilingualism()
        }
    }
    
    @IBOutlet weak var textViewBg: UIView! {
        didSet {
            textViewBg.applyCornerRadius(7)
        }
    }
    
    @IBOutlet weak var textView: QMUITextView! {
        didSet {
            textView.placeholder = "请输入助记词".toMultilingualism()
        }
    }
    
    @IBOutlet weak var pasteButton: UIButton! {
        didSet {
            pasteButton.setTitle("粘贴".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var desLabel: UILabel! {
        didSet {
            desLabel.text = "导入说明".toMultilingualism()
        }
    }
    
    @IBOutlet weak var doneButton: UIButton! {
        didSet {
            doneButton.setupAPPUISolidStyle(title: "导入".toMultilingualism())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func bind() {
        pasteButton.rx.tap.subscribe(onNext: {[weak self] _ in
            
            if let text = UIPasteboard.general.string {
                self?.textView.text = text
            }
            
        }).disposed(by: rx.disposeBag)
        
        textView.rx.text.changed.skip { str in
            return str?.isEmpty ?? true
        }.subscribe(onNext: {[weak self] str in
            if str?.components(separatedBy: CharacterSet.whitespaces).count ?? 0 >= 12 {
                self?.doneButton.isEnabled = true
            } else {
                self?.doneButton.isEnabled = false
            }
            
        }).disposed(by: rx.disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            guard let res = this.textView.text else {
                return
            }
            let msg = LocaleWalletManager.shared().importWallet(mnemonic: res, walletName: "")
            if msg.isNotNilNotEmpty {
                APPHUD.flash(text: msg)
                return
            }
            
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_celebration"), title: "恭喜添加账户".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "现在您可以探索优宝钱包啦".toMultilingualism(), leftButton: nil, rightButton: "立即体验".toMultilingualism(), textAlignment: .center).subscribe { index in
                if index == 1 {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }.disposed(by: this.rx.disposeBag)
            
            
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "wallet_i_have_wallet2".toMultilingualism()
    }
}
