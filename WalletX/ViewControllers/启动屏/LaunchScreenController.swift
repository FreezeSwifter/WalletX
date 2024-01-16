//
//  LaunchScreenController.swift
//  WalletX
//
//  Created by DZSB-001968 on 15.1.24.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit

class LaunchScreenController: UIViewController {

    private var dismissActionBlock: (() -> Void)?
    
    @IBOutlet weak var serverDesLabel: UILabel! {
        didSet {
            serverDesLabel.textColor = ColorConfiguration.blodText.toColor()
            serverDesLabel.text = "客服联系方式".toMultilingualism()
        }
    }
    @IBOutlet weak var tgLabel: UILabel! {
        didSet {
            tgLabel.textColor = ColorConfiguration.blodText.toColor()
        }
    }
    
    @IBOutlet weak var tgButton: UIButton!
    
    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.textColor = ColorConfiguration.blodText.toColor()
        }
    }
    
    @IBOutlet weak var view2: UIView!
    
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var stack1: UIStackView! {
        didSet {
            stack1.isLayoutMarginsRelativeArrangement = true
            stack1.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    @IBOutlet weak var desLabel1: UILabel! {
        didSet {
            desLabel1.textColor = ColorConfiguration.blodText.toColor()
            desLabel1.text = "启动页文本".toMultilingualism()
            desLabel1.qmui_lineHeight = 24
        }
    }
    
    @IBOutlet weak var logo: UIImageView! {
        didSet {
            if LanguageManager.shared().currentCode == .cn {
                logo.image = UIImage.init(named: "wallet_log_cn")
            } else {
                logo.image = UIImage.init(named: "wallet_log_en")
            }
        }
    }
    
    @IBOutlet weak var appName: UILabel! {
        didSet {
            appName.textColor = ColorConfiguration.blodText.toColor()
            appName.text = "优宝钱包".toMultilingualism()
        }
    }
    
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.textColor = ColorConfiguration.blodText.toColor()
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            versionLabel.text = "v\(appVersion)"
        }
    }
    
    @IBOutlet weak var deviceLabel: UILabel! {
        didSet {
            deviceLabel.text = UIDevice.current.identifierForVendor?.uuidString
        }
    }
    
    @IBOutlet weak var deviceButton: UIButton!
    
    @IBOutlet weak var stack2: UIStackView! {
        didSet {
            stack2.layer.cornerRadius = 12
            stack2.layer.borderWidth = 1
            stack2.layer.borderColor = ColorConfiguration.garyLine.toColor().cgColor
        }
    }
    
    @IBOutlet weak var redLabel: UILabel! {
        didSet {
            redLabel.text = "您的设备已被禁用".toMultilingualism()
        }
    }
    
    func setupDismissBlock(actionBlock: @escaping () -> Void) {
        dismissActionBlock = actionBlock
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        deviceButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.deviceLabel.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        tgButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.tgLabel.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        emailButton.rx.tap.subscribe(onNext: {[weak self] in
            UIPasteboard.general.string = self?.emailLabel.text
            APPHUD.flash(text: "成功".toMultilingualism())
        }).disposed(by: rx.disposeBag)
        
        APIProvider.rx.request(.userTerminal).mapJSON().subscribe {[weak self] obj in
            guard let this = self, let dict = obj as? [String: Any], let code = dict["code"] as? Int else { return }
            if code == 0 {
                this.view1.isHidden = false
                this.view2.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self?.dismissActionBlock?()
                })
            } else {
                let data = dict["data"] as? [String: Any]
                this.tgLabel.text = data?["customerTg"] as? String
                this.emailLabel.text = data?["customerEmail"] as? String
                this.view1.isHidden = true
                this.view2.isHidden = false
            }
            
        } onFailure: {[weak self] error in
            self?.dismissActionBlock?()
        }.disposed(by: rx.disposeBag)

    }
}
