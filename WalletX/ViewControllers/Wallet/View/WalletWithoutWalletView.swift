//
//  WalletWithoutWalletView.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.8.23.
//

import UIKit
import SnapKit
import JXSegmentedView
import RxCocoa
import RxSwift
import NSObject_Rx

class WalletWithoutWalletView: UIView {
    
    weak var ovc: OverlayController?
    
    @IBOutlet weak var logImageView: UIImageView! {
        didSet {
            switch LanguageManager.shared().currentCode {
            case .cn:
                logImageView.image = UIImage(named: "wallet_log_cn")
            case .en:
                logImageView.image = UIImage(named: "wallet_log_en")
            }
        }
    }
    
    @IBOutlet weak var desLabel: UILabel! {
        didSet {
            desLabel.minimumScaleFactor = 0.5
            desLabel.adjustsFontSizeToFitWidth = true
            desLabel.textColor = ColorConfiguration.descriptionText.toColor()
            desLabel.text = "wallet_nowallet_des".toMultilingualism()
        }
    }
    
    @IBOutlet weak var noWaleetStack: UIStackView! {
        didSet {
            noWaleetStack.applyCornerRadius(10)
            noWaleetStack.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(WalletWithoutWalletView.createWalletTap))
            noWaleetStack.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var hasWalletStack: UIStackView! {
        didSet {
            hasWalletStack.applyCornerRadius(10)
            hasWalletStack.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(WalletWithoutWalletView.importWalletTap))
            hasWalletStack.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var noWalletLabel1: UILabel! {
        didSet {
            noWalletLabel1.textColor = ColorConfiguration.wihteText.toColor()
            noWalletLabel1.text = "wallet_i_have_nowallet".toMultilingualism()
        }
    }
    
    @IBOutlet weak var noWalletLabel2: UILabel! {
        didSet {
            noWalletLabel2.textColor = ColorConfiguration.wihteAlpha80.toColor()
            noWalletLabel2.text = "wallet_i_have_nowallet2".toMultilingualism()
        }

    }
     
    @IBOutlet weak var hasWalletLabel1: UILabel! {
        didSet {
            hasWalletLabel1.textColor = ColorConfiguration.wihteText.toColor()
            hasWalletLabel1.text = "wallet_i_have_wallet".toMultilingualism()
        }
    }
    
    @IBOutlet weak var hasWalletLabel2: UILabel! {
        didSet {
            hasWalletLabel2.textColor = ColorConfiguration.wihteAlpha80.toColor()
            hasWalletLabel2.text = "wallet_i_have_wallet2".toMultilingualism()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = ColorConfiguration.grayBg.toColor()
        bind()
    }
    
    private func bind() {
        
        LanguageManager.shared().languageDidChanged.subscribe(onNext: {[weak self] code in
            switch code {
            case .cn:
                self?.logImageView.image = UIImage(named: "wallet_log_cn")
            case .en:
                self?.logImageView.image = UIImage(named: "wallet_log_en")
            case .none:
                break
            }
            self?.desLabel.text = "wallet_nowallet_des".toMultilingualism()
            self?.noWalletLabel1.text = "wallet_i_have_nowallet".toMultilingualism()
            self?.noWalletLabel2.text = "wallet_i_have_nowallet2".toMultilingualism()
            self?.hasWalletLabel1.text = "wallet_i_have_wallet".toMultilingualism()
            self?.hasWalletLabel2.text = "wallet_i_have_wallet2".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    @objc
    private func createWalletTap() {
        let vc: CreateWalletStepOneController = ViewLoader.Storyboard.controller(from: "Wallet")
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
   
    @objc
    private func importWalletTap() {
        let vc: ImportWalletController = ViewLoader.Storyboard.controller(from: "Wallet")
        vc.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
