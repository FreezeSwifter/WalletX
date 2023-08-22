//
//  SettingChildViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import LocalAuthentication
import MMKV


class SettingChildViewController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var cnLabel: UILabel! {
        didSet {
            cnLabel.textColor = ColorConfiguration.blackText.toColor()
            cnLabel.text = "home_setting_cn".toMultilingualism()
        }
    }
    
    @IBOutlet weak var cnCheckImg: UIImageView!
    
    @IBOutlet weak var enCheckImg: UIImageView!
    
    @IBOutlet weak var enLabel: UILabel! {
        didSet {
            enLabel.textColor = ColorConfiguration.blackText.toColor()
            enLabel.text = "home_setting_en".toMultilingualism()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func bind() {
        setupDisplayImage()
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            
            self?.cnLabel.text = "home_setting_cn".toMultilingualism()
            self?.enLabel.text = "home_setting_en".toMultilingualism()
            self?.headerView?.titleLabel.text = "home_setting_Language".toMultilingualism()
        }).disposed(by: rx.disposeBag)
    }
    
    private func setupDisplayImage() {
        switch LanguageManager.shared().currentCode {
        case .cn:
            cnCheckImg.image = UIImage(named: "guarantee_selected")
            enCheckImg.image = nil
        case .en:
            enCheckImg.image = UIImage(named: "guarantee_selected")
            cnCheckImg.image = nil
        }
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "home_setting_Language".toMultilingualism()
        headerView?.settingButton.rx.tap.subscribe(onNext: {[weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: rx.disposeBag)
        
    }
    
    @IBAction func cnTap(_ sender: UIControl) {
        LanguageManager.shared().switchLanguage(to: .cn)
        setupDisplayImage()
    }
    
    @IBAction func enTap(_ sender: UIControl) {
        LanguageManager.shared().switchLanguage(to: .en)
        setupDisplayImage()
    }
}
