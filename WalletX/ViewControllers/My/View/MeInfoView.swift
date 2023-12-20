//
//  MeInfoView.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit
import Kingfisher
import QMUIKit

class MeInfoView: UIView {
    
    var userInfo: UserInfoModel? {
        didSet {
            setupData()
        }
    }
    
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
            telegramLabel.text = "Telegram: \("--")"
        }
    }
    
    @IBOutlet weak var levelStackView: UIStackView! {
        didSet{
            levelStackView.backgroundColor = ColorConfiguration.primary.toColor().withAlphaComponent(0.15)
            levelStackView.isLayoutMarginsRelativeArrangement = true
            levelStackView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
            levelStackView.applyCornerRadius(2)
        }
    }
    
    @IBOutlet weak var levelLabel: UILabel! {
        didSet {
            levelLabel.textColor = ColorConfiguration.primary.toColor()
            levelLabel.text = "Lv1"
        }
    }
    
    @IBOutlet weak var walletAddressDes: UILabel! {
        didSet {
            walletAddressDes.textColor = ColorConfiguration.descriptionText.toColor()
            walletAddressDes.text = nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
    }
    
    private func setupData() {

        nameLabel.text = userInfo?.data?.nickName ?? LocaleWalletManager.shared().userInfo?.data?.walletId
        let walletString = userInfo?.data?.walletId ?? "me_noCreate".toMultilingualism()
        walletLabel.text = "\("me_walletId".toMultilingualism()): \(walletString)"
        let telegramString = userInfo?.data?.tg ?? "未设置".toMultilingualism()
        telegramLabel.text = "Telegram: \(telegramString)"
        avatarImageView.kf.setImage(with: URL(string: userInfo?.data?.headImage ?? ""), placeholder: UIImage(named: "logo"))
        let levelString = "Lv\(userInfo?.data?.creditLevel ?? 1)"
        levelLabel.text = levelString
    }
}
