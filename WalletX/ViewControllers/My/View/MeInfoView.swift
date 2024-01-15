//
//  MeInfoView.swift
//  WalletX
//
//  Created by DZSB-001968 on 16.8.23.
//

import UIKit
import Kingfisher
import QMUIKit
import RxSwift

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
    
    @IBOutlet weak var copyWalletBtn: UIButton! {
        didSet {
            copyWalletBtn.setTitle("", for: .normal)
        }
    }
    
    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(telegramEdit))
    
    
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
        copyWalletBtn.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.userInfo?.data?.walletId
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        telegramLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func telegramEdit() {
        if let tg = userInfo?.data?.tg, !tg.isEmpty {
        } else {
            SettingModifyAlterView.show(title: "home_setting_telegram".toMultilingualism(), text: nil, placeholder: "请输入".toMultilingualism(), leftButtonTitle: "取消".toMultilingualism(), rightButtonTitle: "确定".toMultilingualism()).flatMapLatest { str in
                
                guard let text = str, text.isNotEmpty else {
                    return Observable<Any>.empty()
                }
                let dict: [String: Any] = ["tg": text]
                return APIProvider.rx.request(.userInfoSetting(info: dict)).mapJSON().asObservable()
                
            }.subscribe(onNext: { _ in
                APPHUD.flash(text: "成功".toMultilingualism())
                NotificationCenter.default.post(name: .userInfoDidChangeed, object: nil)
            }).disposed(by: rx.disposeBag)
        }
    }
}
