//
//  AppDelegate.swift
//  WalletX
//
//  Created by DZSB-001968 on 10.8.23.
//

import UIKit
import IQKeyboardManager
import QMUIKit
import RxCocoa
import RxSwift
import SwiftDate
import NSObject_Rx

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let tabBarViewController = QMUITabBarViewController()
    private let messageDataSubject = BehaviorRelay<[MessageListModel]?>(value: nil)
    
    var messageData: Observable<[MessageListModel]?> {
        return messageDataSubject.asObservable()
    }
    
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
    
    func tabBarSelecte(index: Int) {
        tabBarViewController.selectedIndex = index
    }
    
    func cleanMessageItemRedDot() {
        tabBarViewController.children[2].tabBarItem.qmui_shouldShowUpdatesIndicator = false
    }
    
}

private
extension AppDelegate {
    
    func commonInit() {
        
        AppArchiveder.shared()
        
        LocaleWalletManager.shared()
        
        SwiftDate.defaultRegion = Region.current
        
        QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = { identifier -> NSObject in
            return QMUIConfigurationTemplate.init()
        }
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldPlayInputClicks = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
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
        
        let childs = [guranteeNavi, walletNavi, messageNavi, myNavi]
        tabBarViewController.viewControllers = childs
        window?.rootViewController = tabBarViewController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        LocaleWalletManager.shared()
        
        setupObserver()
        autoLogin()
        checkFaceId()
        fetchAPPConfig()
        fetchMessage()
    }
    
    func createTabBarItem(title: String, image: UIImage, selecteColor: UIColor, tag: Int) -> UITabBarItem {
        let item = UITabBarItem(title: title, image: image, tag: tag)
        item.selectedImage = image.qmui_image(withTintColor: selecteColor)
        return item
    }
    
    func setupObserver() {
        
        UIApplication.shared.rx.applicationWillEnterForeground.subscribe(onNext: {[weak self] _ in
            self?.checkFaceId()
            self?.autoLogin()
        }).disposed(by: rx.disposeBag)
        
        LocaleWalletManager.shared().walletDidChanged.observe(on: MainScheduler.instance).subscribe(onNext: {[weak self] _ in
            guard let this = self else { return }
            this.autoLogin()
        }).disposed(by: rx.disposeBag)
    }
    
    func autoLogin() {
        let req: Observable<LoginModel?> = APIProvider.rx.request(.login(walletAddr: LocaleWalletManager.shared().TRON?.address ?? "")).mapModel()
        req.subscribe(onNext: { model in
            
            guard let addressKey = LocaleWalletManager.shared().TRON?.address?.md5() else { return }
            guard let jsonString = model?.toJSONString() else { return }
            AppArchiveder.shared().mmkv?.set(jsonString, forKey: addressKey)
            
        }).disposed(by: rx.disposeBag)
    }
    
    func checkFaceId() {
        if let isOpenLock = AppArchiveder.shared().mmkv?.bool(forKey: ArchivedKey.screenLock.rawValue), isOpenLock {
            let faceIdVC: FaceIDViewController = ViewLoader.Xib.controller()
            faceIdVC.modalPresentationStyle = .fullScreen
            AppDelegate.topViewController()?.present(faceIdVC, animated: true)
        }
    }
    
    func fetchAPPConfig() {
        let req: Observable<[AppSystemConfigModel]> = APIProvider.rx.request(.systemConfigFind).mapModelArray()
        req.subscribe(onNext: { list in
            AppArchiveder.shared().setupAppConfigs(data: list)
        }).disposed(by: rx.disposeBag)
    }
    
    func fetchMessage() {
        let req: Observable<[MessageListModel]> = APIProvider.rx.request(.messageList).mapModelArray()
        req.subscribe(onNext: {[weak self] list in
            self?.messageDataSubject.accept(list)
            let unread = list.filter { $0.status == 0 }
            if unread.count > 0 {
                self?.tabBarViewController.children[2].tabBarItem.qmui_shouldShowUpdatesIndicator = true
                self?.tabBarViewController.children[2].tabBarItem.qmui_badgeInteger = 0
            }
        }).disposed(by: rx.disposeBag)
    }
    
}


final class APPNavigationController: QMUINavigationController {}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController ?? UIViewController()) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
