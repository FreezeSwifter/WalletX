//
//  ContactOtherController.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import QMUIKit
import Then
import NSObject_Rx

class ContactOtherController: UIViewController, HomeNavigationble {

    var orderInfoModel: GuaranteeInfoModel.Meta?
    
    var partnerUser: String?
    
    // 被邀请人钱包id
    var walletId: String? {
        didSet {
            if let id = walletId {
                fetchData(walletId: id)
            }
        }
    }
    
    private(set) var userModel: UserInfoModel? {
        didSet {
            updateValue()
        }
    }
    
    @IBOutlet weak var telegramLabel: UILabel! {
        didSet {
            telegramLabel.text = "home_setting_telegram".toMultilingualism()
        }
    }
    
    @IBOutlet weak var telegramTextField: UITextField! {
        didSet {
            telegramTextField.placeholder = nil
            telegramTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var telegramCopyButton: UIButton! {
        didSet {
            telegramCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var telegramBg: UIView! {
        didSet {
            telegramBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var tContactButton: UIButton! {
        didSet {
            tContactButton.setTitle("立即对话".toMultilingualism(), for: .normal)
            tContactButton.layer.cornerRadius = 7
            tContactButton.backgroundColor = ColorConfiguration.primary.toColor()
            tContactButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            tContactButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.text = "home_setting_email".toMultilingualism()
        }
    }
    
    @IBOutlet weak var emailBg: UIView! {
        didSet {
            emailBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = nil
            emailTextField.isUserInteractionEnabled = false
        }
    }
    
    @IBOutlet weak var eamilCopyButton: UIButton! {
        didSet {
            eamilCopyButton.setTitle("share_Copy".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var gmailButton: UIButton! {
        didSet {
            gmailButton.setTitle("Gmail邮箱".toMultilingualism(), for: .normal)
            gmailButton.layer.cornerRadius = 7
            gmailButton.backgroundColor = ColorConfiguration.primary.toColor()
            gmailButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            gmailButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
            gmailButton.isHidden = true
        }
    }
    
    @IBOutlet weak var qqButton: UIButton! {
        didSet {
            qqButton.setTitle("QQ邮箱".toMultilingualism(), for: .normal)
            qqButton.layer.cornerRadius = 7
            qqButton.backgroundColor = ColorConfiguration.primary.toColor()
            qqButton.setTitleColor(ColorConfiguration.wihteText.toColor(), for: .normal)
            qqButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
            qqButton.isHidden = true
        }
    }
    
    @IBOutlet weak var recommendLabel: UILabel! {
        didSet {
            recommendLabel.text = "推荐发送内容".toMultilingualism()
        }
    }
    
    @IBOutlet weak var pasteButton: UIButton!
    
    @IBOutlet weak var recommendBg: UIView! {
        didSet {
            recommendBg.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var recommendContentLabel: UILabel! {
        didSet {
            recommendContentLabel.text = "--"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func updateValue() {
        telegramTextField.text = userModel?.data?.tg
        emailTextField.text = userModel?.data?.email
    }
    
    private func bind() {
        if let id = partnerUser {
            fetchData(walletId: id)
        }
        
        tContactButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.openTg()
        }).disposed(by: rx.disposeBag)
        
        telegramCopyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            UIPasteboard.general.string = self?.userModel?.data?.tg
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
     
        eamilCopyButton.rx.tap.subscribe(onNext: { [weak self] _ in
            UIPasteboard.general.string = self?.userModel?.data?.email
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)

        pasteButton.rx.tap.subscribe(onNext: { [weak self] _ in
            UIPasteboard.general.string = self?.recommendContentLabel.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)

        recommendContentLabel.text = "\("担保金额没有1".toMultilingualism()): \(orderInfoModel?.assureId ?? "--")\n\("担保类型没有3".toMultilingualism()): \(orderInfoModel?.assureTypeToString() ?? "")\n\("担保金额没有1".toMultilingualism()): \(orderInfoModel?.amount ?? 0)USDT"
    }
    
    private func openTg() {
        guard let id = userModel?.data?.tg else { return }
        let appURL = URL(string: "telegram://")!
        if UIApplication.shared.canOpenURL(appURL) {
            let appUrl = URL(string: "tg://resolve?domain=\(id)")
            if let url = appUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                APPHUD.flash(text: "Error")
            }
        } else {
            APPHUD.flash(text: "Not Install Telegram")
        }
    }
    
    private func fetchData(walletId: String) {
        let req: Observable<UserInfoModel?> = APIProvider.rx.request(.queryContactInfo(walletId: walletId)).mapModel()
        req.subscribe(onNext: {[weak self] info in
            self?.userModel = info
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        view.backgroundColor = .white
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.titleLabel.text = "联系对方".toMultilingualism()
        headerView?.backgroundColor = .white
    }
    
}
