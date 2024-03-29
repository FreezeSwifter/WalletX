//
//  FaceIDViewController.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import UIKit
import LocalAuthentication

class FaceIDViewController: UIViewController {
    
    var resultBlock: ((Bool)->Void)?
    
    @IBOutlet weak var lockButton: UIButton! {
        didSet {
            lockButton.setTitle("home_setting_ScreenLock".toMultilingualism(), for: .normal)
        }
    }
    
    @IBOutlet weak var closeButton: UIButton! {
        didSet {
            closeButton.setTitle("关闭".toMultilingualism(), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let context = LAContext()
        var error: NSError?
       
        // TestCode
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            
//            self.resultBlock?(true)
//            self.dismiss(animated: true)
//        })
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "home_setting_ScreenLock".toMultilingualism()
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.dismiss(animated: true, completion: {
                            self?.resultBlock?(true)
                        })
                    }
                }
            }
        } else {
            APPHUD.flash(text: "home_setting_lock_error".toMultilingualism())
            dismiss(animated: true)
        }
    }
    
    @IBAction func closeTap(_ sender: UIButton) {
        dismiss(animated: true) {
            self.resultBlock?(false)
        }
    }
    
    @IBAction func lockButtonTap(_ sender: UIButton) {
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "home_setting_ScreenLock".toMultilingualism()
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {[weak self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self?.dismiss(animated: true)
                    }
                }
            }
        } else {
            APPHUD.flash(text: "home_setting_lock_error".toMultilingualism())
        }
    }
}
