//
//  AppDelegate.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        commonInit()
        
        return true
    }
}

private
extension AppDelegate {
    
    func commonInit() {
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldPlayInputClicks = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
    }
}

