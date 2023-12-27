//
//  SettingViewController.swift
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

class SettingViewController: UIViewController, HomeNavigationble {
    
    @IBOutlet weak var topPadding: NSLayoutConstraint!
    
    @IBOutlet weak var securityLabel: UILabel! {
        didSet {
            securityLabel.textColor = ColorConfiguration.descriptionText.toColor()
            securityLabel.text = "home_setting_security".toMultilingualism()
        }
    }
    
    @IBOutlet weak var securityDesLabel: UILabel! {
        didSet {
            securityDesLabel.textColor = ColorConfiguration.blackText.toColor()
            securityDesLabel.text = "home_setting_ScreenLock".toMultilingualism()
        }
    }
    
    @IBOutlet weak var otherLabel: UILabel! {
        didSet {
            otherLabel.textColor = ColorConfiguration.descriptionText.toColor()
            otherLabel.text = "home_setting_OtherSettings".toMultilingualism()
        }
    }
    
    @IBOutlet weak var languageDesLabel: UILabel! {
        didSet {
            languageDesLabel.textColor = ColorConfiguration.blackText.toColor()
            languageDesLabel.text = "home_setting_Language".toMultilingualism()
        }
    }
    
    @IBOutlet weak var languageValueLabel: UILabel! {
        didSet {
            languageValueLabel.textColor = ColorConfiguration.blackText.toColor()
            languageValueLabel.text = LanguageManager.shared().currentCode.toDisplayText()
        }
    }
    
    @IBOutlet weak var contactDesLabel: UILabel! {
        didSet {
            contactDesLabel.textColor = ColorConfiguration.blackText.toColor()
            contactDesLabel.text = "自动锁定".toMultilingualism()
        }
    }
    
    @IBOutlet weak var contactValueLabel: UILabel! {
        didSet {
            contactValueLabel.textColor = ColorConfiguration.blackText.toColor()
            contactValueLabel.text = nil
        }
    }
    

    @IBOutlet weak var lockSwitch: UISwitch! {
        didSet {
            if let isOpen = AppArchiveder.shared().mmkv?.bool(forKey: ArchivedKey.screenLock.rawValue) {
                lockSwitch.isOn = isOpen
            }
        }
    }
    
    @IBOutlet weak var lockWayDesLabel: UILabel! {
        didSet {
            lockWayDesLabel.text = "锁定方法".toMultilingualism()
        }
    }
    
    @IBOutlet weak var lockWayValue: UILabel! {
        didSet {
            lockWayValue.text = "Face ID".toMultilingualism()
        }
    }
    
    @IBOutlet weak var lockStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
        
        LockManager.shareInstance.rx.observeWeakly(Int.self, "currentIndex").subscribe(onNext: {[unowned self] _ in
            contactValueLabel.text = LockManager.shareInstance.currentItem.name
        }).disposed(by: rx.disposeBag)
    }
    
    private func bind() {
        NotificationCenter.default.rx.notification(.languageChanged).observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            
            self?.securityLabel.text = "home_setting_security".toMultilingualism()
            self?.securityDesLabel.text = "home_setting_ScreenLock".toMultilingualism()
            self?.otherLabel.text = "home_setting_OtherSettings".toMultilingualism()
            self?.headerView?.titleLabel.text = "home_setting".toMultilingualism()
            self?.languageDesLabel.text = "home_setting_Language".toMultilingualism()
            self?.contactDesLabel.text = "home_setting_Contact".toMultilingualism()
        }).disposed(by: rx.disposeBag)
        
        if !lockSwitch.isOn {
            lockStackView.arrangedSubviews.forEach { $0.isHidden = true }
        }
    }
    
    private func setupView() {
        view.backgroundColor = ColorConfiguration.listBg.toColor()
        setupNavigationbar()
        setupChildVCStyle()
        headerView?.backgroundColor = .white
        headerView?.titleLabel.text = "home_setting".toMultilingualism()
        
        topPadding.constant = headerView!.height + UIApplication.shared.statusBarFrame.size.height
    }

    @IBAction func switchTap(_ sender: UISwitch) {
        let context = LAContext()
        var error: NSError?
        let isOn = sender.isOn
        lockStackView.arrangedSubviews.forEach { $0.isHidden = !isOn }
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "home_setting_ScreenLock".toMultilingualism()
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                if success {
                    AppArchiveder.shared().mmkv?.set(isOn, forKey: ArchivedKey.screenLock.rawValue)
                }
            }
        } else {
            DispatchQueue.main.async {
                sender.isOn = false
            }
            APPHUD.flash(text: "home_setting_lock_error".toMultilingualism())
        }
    }
    
    @IBAction func languageTap(_ sender: UIControl) {
        let languageVC: SettingChildViewController = ViewLoader.Xib.controller()
        navigationController?.pushViewController(languageVC, animated: true)
    }
    
    @IBAction func contactTap(_ sender: UIControl) {
        let contactVC: SelectedLockTimeController = ViewLoader.Xib.controller()
        navigationController?.pushViewController(contactVC, animated: true)
    }
    
}
