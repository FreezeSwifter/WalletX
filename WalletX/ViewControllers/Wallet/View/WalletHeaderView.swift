//
//  WalletHeaderView.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.8.23.
//

import UIKit

class WalletHeaderView: UIView {
    
    @IBOutlet weak var topStackBg: UIStackView!
    
    @IBOutlet weak var topButton1: UIButton! {
        didSet {
            topButton1.titleLabel?.minimumScaleFactor = 0.5
            topButton1.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var topButton2: UIButton! {
        didSet {
            topButton2.titleLabel?.minimumScaleFactor = 0.5
            topButton2.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }
    
    @IBOutlet weak var sendDesLabel: UILabel! {
        didSet {
            sendDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
            sendDesLabel.text = "wallet_send".toMultilingualism()
        }
    }
    
    @IBOutlet weak var receiveDesLabel: UILabel! {
        didSet {
            receiveDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
            receiveDesLabel.text = "wallet_receive".toMultilingualism()
        }
    }
    
    @IBOutlet weak var walletDesLabel: UILabel! {
        didSet {
            walletDesLabel.textColor = ColorConfiguration.descriptionText.toColor()
            walletDesLabel.text = "wallet_deposit".toMultilingualism()
        }
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.applyCornerRadius(20)
        }
    }
    
    @IBOutlet weak var receiveButton: UIButton! {
        didSet {
            receiveButton.applyCornerRadius(20)
        }
    }
    
    @IBOutlet weak var walletButton: UIButton! {
        didSet {
            walletButton.applyCornerRadius(20)
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
        backgroundColor = .clear
        
        LanguageManager.shared().languageDidChanged.subscribe(onNext: {[weak self] _ in
            self?.sendDesLabel.text = "wallet_send".toMultilingualism()
            self?.receiveDesLabel.text = "wallet_receive".toMultilingualism()
            self?.walletDesLabel.text = "wallet_deposit".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
