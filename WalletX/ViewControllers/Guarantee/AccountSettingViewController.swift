//
//  AccountSettingViewController.swift
//  WalletX
//
//  Created by 张国忠 on 2023/12/3.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

private class SectionItem: UIControl {
    
    private lazy var containerView: UIView = UIView().then { it in
        it.backgroundColor = .white
    }
    
    private lazy var iconImageView: UIImageView = UIImageView().then { it in
        it.contentMode = .scaleAspectFill
    }
    
    private lazy var sectionTitleLabel: UILabel = UILabel().then { it in
        it.textAlignment = .left
        it.font = UIFont.systemFont(ofSize: 15)
        it.textColor = ColorConfiguration.blackText.toColor()
    }
    
    private lazy var descLabel: UILabel = UILabel().then { it in
        it.textAlignment = .right
        it.font = UIFont.systemFont(ofSize: 15)
        it.textColor = ColorConfiguration.descriptionText.toColor()
    }
    
    private lazy var rightIcon: UIImageView = UIImageView().then { it in
        it.contentMode = .scaleAspectFill
    }
    
    private lazy var lineView: UIView = UIView().then { it in
        it.backgroundColor = UIColor(white: 0, alpha: 0.2)
    }
    
    let button: UIButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(sectionTitleLabel)
        containerView.addSubview(descLabel)
        containerView.addSubview(rightIcon)
        containerView.addSubview(lineView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        sectionTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(descLabel.snp.leading).offset(-5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rightIcon.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        rightIcon.snp.makeConstraints { make in
            make.height.equalTo(11)
            make.width.equalTo(6)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configItem(iconName: String, title:String, rightIconName: String) {
        iconImageView.image = UIImage(named: iconName)
        sectionTitleLabel.text = title
        rightIcon.image = UIImage(named: rightIconName)
    }
    
    func updateItem(with desTitle: String?) {
        descLabel.text = desTitle
    }
}

class SectionItemView: UIView {
    private lazy var sectionTitle: UILabel = UILabel().then { it in
        it.font = UIFont.systemFont(ofSize: 12)
        it.textAlignment = .left
        it.textColor = ColorConfiguration.descriptionText.toColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        addSubview(sectionTitle)
        sectionTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func updateView(with title: String) {
        sectionTitle.text = title
    }
}

class AccountSettingViewController: UIViewController, HomeNavigationble {
    
    private var newNickname: String?
    private var newEmail: String?
    private var newTG: String?
    
    private lazy var accountInfoSectionTitle: SectionItemView = SectionItemView().then { it in
        it.updateView(with: "账户信息".toMultilingualism())
    }
    
    private lazy var accountInfoStackView: UIStackView = UIStackView().then { it in
        it.axis = .vertical
        it.alignment = .fill
        it.distribution = .fill
        it.backgroundColor = .white
    }
    
    private lazy var systemIDItem: SectionItem = SectionItem().then { it in
        it.configItem(iconName: "ic_black_message", title: "账户ID".toMultilingualism(), rightIconName: "ic_join_guarantee_copy")
    }
    
    private lazy var nickNameItem: SectionItem = SectionItem().then { it in
        it.configItem(iconName: "guarantee_setting_nickname", title: "home_setting_Nickname".toMultilingualism(), rightIconName: "global_list_right_arrow")
    }
    
    private lazy var concactSectionTitle: SectionItemView = SectionItemView().then { it in
        it.updateView(with: "home_setting_Contact".toMultilingualism())
    }
    
    private lazy var concactStackView: UIStackView = UIStackView().then { it in
        it.axis = .vertical
        it.alignment = .fill
        it.distribution = .fill
        it.backgroundColor = .white
    }
    
    private lazy var telegramItem: SectionItem = SectionItem().then { it in
        it.configItem(iconName: "guarantee_setting_telegram", title: "home_setting_telegram".toMultilingualism(), rightIconName: "global_list_right_arrow")
    }
    
    private lazy var emailItem: SectionItem = SectionItem().then { it in
        it.configItem(iconName: "guarantee_setting_email", title: "home_setting_email".toMultilingualism(), rightIconName: "global_list_right_arrow")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationbar()
        setupChildVCStyle()
        
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "账户设置".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(accountInfoSectionTitle)
        view.addSubview(accountInfoStackView)
        accountInfoStackView.addArrangedSubview(systemIDItem)
        accountInfoStackView.addArrangedSubview(nickNameItem)
        view.addSubview(concactSectionTitle)
        view.addSubview(concactStackView)
        concactStackView.addArrangedSubview(telegramItem)
        concactStackView.addArrangedSubview(emailItem)
        
        accountInfoSectionTitle.snp.makeConstraints { make in
            if let headerView = headerView {
                make.top.equalTo(headerView.snp.bottom)
            }
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        accountInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(accountInfoSectionTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        systemIDItem.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        nickNameItem.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        concactSectionTitle.snp.makeConstraints { make in
            make.top.equalTo(accountInfoStackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        concactStackView.snp.makeConstraints { make in
            make.top.equalTo(concactSectionTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        telegramItem.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        emailItem.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
        
        systemIDItem.updateItem(with: LocaleWalletManager.shared().userInfo?.data?.walletId ?? "--")
        nickNameItem.updateItem(with: LocaleWalletManager.shared().userInfo?.data?.nickName ?? "--")
        emailItem.updateItem(with: LocaleWalletManager.shared().userInfo?.data?.email ?? "--")
        telegramItem.updateItem(with: LocaleWalletManager.shared().userInfo?.data?.tg ?? "--")
        
        systemIDItem.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {
            UIPasteboard.general.string = LocaleWalletManager.shared().userInfo?.data?.walletId
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        nickNameItem.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[unowned self] in
            func filterSpecialCharactersAndEmojis(from string: String) -> String {
                do {
                    let regex = try NSRegularExpression(pattern: "[^a-zA-Z0-9\\s]", options: .caseInsensitive)
                    let range = NSMakeRange(0, string.count)
                    let filteredString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
                    return filteredString
                } catch {
                    print("Error creating regular expression: \(error)")
                    return string
                }
            }
            
            SettingModifyAlterView.show(title: "home_setting_Nickname".toMultilingualism(), text: nil, placeholder: "请输入".toMultilingualism(), leftButtonTitle: "取消".toMultilingualism(), rightButtonTitle: "确定".toMultilingualism()).flatMapLatest {[weak self] str in
                
                guard let text = str, text.isNotEmpty else {
                    return Observable<Any>.empty()
                }
                let filteredString = filterSpecialCharactersAndEmojis(from: text)
                self?.newNickname = filteredString
                let dict: [String: Any] = ["nickName": filteredString]
                return APIProvider.rx.request(.userInfoSetting(info: dict)).mapJSON().asObservable()
                
            }.subscribe(onNext: {[weak self] _ in
                self?.nickNameItem.updateItem(with: self?.newNickname)
                APPHUD.flash(text: "成功".toMultilingualism())
                NotificationCenter.default.post(name: .userInfoDidChangeed, object: nil)
            }).disposed(by: rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        emailItem.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[unowned self] _ in
            SettingModifyAlterView.show(title: "home_setting_email".toMultilingualism(), text: nil, placeholder: "请输入".toMultilingualism(), leftButtonTitle: "取消".toMultilingualism(), rightButtonTitle: "确定".toMultilingualism()).flatMapLatest {[weak self] str in
                
                guard let text = str, text.isNotEmpty else {
                    return Observable<Any>.empty()
                }
                func isValidEmail(email: String) -> Bool {
                    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                    let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                    return emailPred.evaluate(with: email)
                }
                if !isValidEmail(email: text) {
                    APPHUD.flash(text: "请填写有效邮箱".toMultilingualism())
                    return Observable<Any>.empty()
                }
                self?.newEmail = text
                let dict: [String: Any] = ["email": text]
                return APIProvider.rx.request(.userInfoSetting(info: dict)).mapJSON().asObservable()
                
            }.subscribe(onNext: {[weak self] _ in
                self?.emailItem.updateItem(with: self?.newEmail)
                APPHUD.flash(text: "成功".toMultilingualism())
                NotificationCenter.default.post(name: .userInfoDidChangeed, object: nil)
            }).disposed(by: rx.disposeBag)
            
        }).disposed(by: rx.disposeBag)
        
        telegramItem.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[unowned self] _ in
            SettingModifyAlterView.show(title: "home_setting_telegram".toMultilingualism(), text: nil, placeholder: "请输入".toMultilingualism(), leftButtonTitle: "取消".toMultilingualism(), rightButtonTitle: "确定".toMultilingualism()).flatMapLatest {[weak self] str in
                
                guard let text = str, text.isNotEmpty else {
                    return Observable<Any>.empty()
                }
                self?.newTG = text
                let dict: [String: Any] = ["tg": text]
                return APIProvider.rx.request(.userInfoSetting(info: dict)).mapJSON().asObservable()
                
            }.subscribe(onNext: {[weak self] _ in
                self?.telegramItem.updateItem(with: self?.newTG)
                APPHUD.flash(text: "成功".toMultilingualism())
                NotificationCenter.default.post(name: .userInfoDidChangeed, object: nil)
            }).disposed(by: rx.disposeBag)
        }).disposed(by: rx.disposeBag)
        
    }
}
