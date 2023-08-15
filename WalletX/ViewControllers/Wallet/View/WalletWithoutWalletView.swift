//
//  WalletWithoutWalletView.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.8.23.
//

import UIKit


class WalletWithoutWalletView: UIView {
    
    @IBOutlet weak var topLabel: UILabel! {
        didSet {
            topLabel.minimumScaleFactor = 0.8
            topLabel.textColor = ColorConfiguration.blodText.toColor()
            topLabel.text = "wallet_nowallet_title".toMultilingualism()
        }
    }
    
    @IBOutlet weak var desLabel: UILabel! {
        didSet {
            desLabel.minimumScaleFactor = 0.8
            desLabel.textColor = ColorConfiguration.descriptionText.toColor()
            desLabel.text = "wallet_nowallet_des".toMultilingualism()
        }
    }
    
    @IBOutlet weak var noWaleetStack: UIStackView! {
        didSet {
            noWaleetStack.applyCornerRadius(10)
        }
    }
    
    @IBOutlet weak var hasWalletStack: UIStackView! {
        didSet {
            hasWalletStack.applyCornerRadius(10)
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
    }
    
}
