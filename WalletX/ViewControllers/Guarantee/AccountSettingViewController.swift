//
//  AccountSettingViewController.swift
//  WalletX
//
//  Created by 张国忠 on 2023/12/3.
//

import UIKit
import Then
import SnapKit

class SectionItem: UIControl {
    
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
    }
    
    func configItem(iconName: String, title:String, rightIconName: String) {
        iconImageView.image = UIImage(named: iconName)
        sectionTitleLabel.text = title
        rightIcon.image = UIImage(named: rightIconName)
    }
    
    func updateItem(with desTitle: String) {
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
        it.configItem(iconName: "ic_black_message", title: "账户ID", rightIconName: "ic_join_guarantee_copy")
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
    }
}
