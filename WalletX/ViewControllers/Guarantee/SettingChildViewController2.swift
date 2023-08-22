//
//  SettingChildViewController2.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import UIKit

class SettingChildViewController2: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var telegramDesLabel: UILabel! {
        didSet {
            telegramDesLabel.textColor = ColorConfiguration.blackText.toColor()
            telegramDesLabel.text = "home_setting_telegram".toMultilingualism()
        }
    }
    
    @IBOutlet weak var emailDesLabel: UILabel! {
        didSet {
            emailDesLabel.textColor = ColorConfiguration.blackText.toColor()
            emailDesLabel.text = "home_setting_email".toMultilingualism()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "home_setting_Contact".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
    
}
