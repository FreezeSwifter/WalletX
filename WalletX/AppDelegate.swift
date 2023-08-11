//
//  AppDelegate.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import IQKeyboardManager
import QMUIKit

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
        
        QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = { identifier -> NSObject in
            return QMUIConfigurationTemplate.init()
        }
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldPlayInputClicks = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarViewController = QMUITabBarViewController()
        // 担保
        let guranteeVC = GuranteeViewController()
        guranteeVC.hidesBottomBarWhenPushed = false
        let guranteeNavi = QMUINavigationController(rootViewController: guranteeVC)
        guranteeVC.tabBarItem = createTabBarItem(title: "A", image: UIImage(named: "tabbar_gurantee_item")!, selecteColor: UIColor.qmui_color(withHexString: "4162FF")!, tag: 0)
        
        // 钱包
        let walletVC = WalletViewController()
        walletVC.hidesBottomBarWhenPushed = false
        let walletNavi = QMUINavigationController(rootViewController: walletVC)
        walletVC.tabBarItem = createTabBarItem(title: "B", image: UIImage(named: "tabbar_wallet_item")!, selecteColor: UIColor.qmui_color(withHexString: "4162FF")!, tag: 1)
        
        // 消息
        let messageVC = MessageViewController()
        messageVC.hidesBottomBarWhenPushed = false
        let messageNavi = QMUINavigationController(rootViewController: messageVC)
        messageVC.tabBarItem = createTabBarItem(title: "c", image: UIImage(named: "tabbar_message_item")!, selecteColor: UIColor.qmui_color(withHexString: "4162FF")!, tag: 2)
        
        // 我的
        let myVC = MyViewController()
        myVC.hidesBottomBarWhenPushed = false
        let myNavi = QMUINavigationController(rootViewController: myVC)
        myVC.tabBarItem = createTabBarItem(title: "d", image: UIImage(named: "tabbar_my_item")!, selecteColor: UIColor.qmui_color(withHexString: "4162FF")!, tag: 3)
     
        tabBarViewController.viewControllers = [guranteeNavi, walletNavi, messageNavi, myNavi];
        window?.rootViewController = tabBarViewController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
    }
    
    func createTabBarItem(title: String, image: UIImage, selecteColor: UIColor, tag: Int) -> UITabBarItem {
        let item = UITabBarItem(title: title, image: image, tag: tag)
        item.selectedImage = image.qmui_image(withTintColor: selecteColor)
        return item
    }
}

