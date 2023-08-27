//
//  MeInfoView.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit

class MeInfoView: UIView {
        
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.applyCornerRadius(avatarImageView.bounds.width / 2)
            avatarImageView.backgroundColor = ColorConfiguration.grayBg.toColor()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = ColorConfiguration.blackText.toColor()
            nameLabel.text = "--"
        }
    }
    
    @IBOutlet weak var walletLabel: UILabel! {
        didSet {
            walletLabel.textColor = ColorConfiguration.descriptionText.toColor()
            walletLabel.text = "\("me_walletId".toMultilingualism()): \("me_noCreate".toMultilingualism())"
        }
    }
    
    @IBOutlet weak var telegramLabel: UILabel! {
        didSet {
            telegramLabel.textColor = ColorConfiguration.descriptionText.toColor()
            telegramLabel.text = "Telegram: \("me_noBind".toMultilingualism())"
        }
    }
    
    @IBOutlet weak var levelStackView: UIStackView! {
        didSet{
            levelStackView.backgroundColor = ColorConfiguration.primary.toColor().withAlphaComponent(0.15)
        }
    }
    
    @IBOutlet weak var levelLabel: UILabel! {
        didSet {
            levelLabel.textColor = ColorConfiguration.primary.toColor()
            levelLabel.text = "Lv1"
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
    }
}
