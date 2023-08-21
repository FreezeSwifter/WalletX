//
//  AppDelegate.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import IQKeyboardManager
import QMUIKit
import MMKV

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        commonInit()
        
        return true
    }
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}

private
extension AppDelegate {
    
    func commonInit() {
        
        MMKV.initialize(rootDir: nil)
        
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
        let guranteeNavi = APPNavigationController(rootViewController: guranteeVC)
        guranteeVC.tabBarItem = createTabBarItem(title: "tab_guaranties".toMultilingualism(), image: UIImage(named: "tabbar_gurantee_item")!, selecteColor: ColorConfiguration.primary.toColor(), tag: 0)
        
        // 钱包
        let walletVC = WalletViewController()
        walletVC.hidesBottomBarWhenPushed = false
        let walletNavi = APPNavigationController(rootViewController: walletVC)
        walletVC.tabBarItem = createTabBarItem(title: "tab_wallet".toMultilingualism(), image: UIImage(named: "tabbar_wallet_item")!, selecteColor: ColorConfiguration.primary.toColor(), tag: 1)
        
        // 消息
        let messageVC = MessageViewController()
        messageVC.hidesBottomBarWhenPushed = false
        let messageNavi = APPNavigationController(rootViewController: messageVC)
        messageVC.tabBarItem = createTabBarItem(title: "tab_message".toMultilingualism(), image: UIImage(named: "tabbar_message_item")!, selecteColor: ColorConfiguration.primary.toColor(), tag: 2)
        
        // 我的
        let myVC = MyViewController()
        myVC.hidesBottomBarWhenPushed = false
        let myNavi = APPNavigationController(rootViewController: myVC)
        myVC.tabBarItem = createTabBarItem(title: "tab_me".toMultilingualism(), image: UIImage(named: "tabbar_my_item")!, selecteColor: ColorConfiguration.primary.toColor(), tag: 3)
        
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


final class APPNavigationController: QMUINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        switch viewController {
        case is MessageViewController, is GuranteeViewController, is WalletViewController, is MyViewController:
            break
        default:
            viewController.hidesBottomBarWhenPushed = true
        }
    }
}


