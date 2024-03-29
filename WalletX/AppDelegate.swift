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
struct MyAPP {
    static func main() {
        UITextField.swizzleMethod
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?
    private var serviceInfo: String?
    private var childVCs: [UIViewController] = []
    private let launch: LaunchScreenController = ViewLoader.Xib.controller()
    
    private var tabBarViewController: QMUITabBarViewController = {
        let tabbarVC = QMUITabBarViewController()
        return tabbarVC
    }()
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
    
    func openTg() {
        guard let id = serviceInfo else {
            APPHUD.flash(text: "Error".toMultilingualism())
            return
        }
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
    
    func fetchMessage() {
        let req: Observable<[MessageListModel]> = APIProvider.rx.request(.messageList).mapModelArray()
        req.subscribe { [weak self] list in
            self?.messageDataSubject.accept(list)
            let unread = list.filter { $0.status == 0 }
            if unread.count > 0 {
                self?.tabBarViewController.children[2].tabBarItem.qmui_shouldShowUpdatesIndicator = true
                self?.tabBarViewController.children[2].tabBarItem.qmui_badgeInteger = 0
            } else {
                self?.tabBarViewController.children[2].tabBarItem.qmui_shouldShowUpdatesIndicator = false
            }
            
        } onError: {[weak self] e in
            let error = e as NSError
            if error.code == 11 {
                self?.tabBarViewController.children[2].tabBarItem.qmui_shouldShowUpdatesIndicator = false
                NotificationCenter.default.post(name: .deviceDisabled, object: nil)
            }
        }.disposed(by: rx.disposeBag)

    }
    
    func setupWindow() {
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
        
        childVCs = [guranteeNavi, walletNavi, messageNavi, myNavi]
        tabBarViewController.viewControllers = childVCs
        
        window?.rootViewController = launch
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        launch.setupDismissBlock {[weak self] in
            guard let this = self else { return }
            this.window?.rootViewController = this.tabBarViewController
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3 {
            if !LocaleWalletManager.shared().hasWallet {
                tabBarController.selectedIndex = 0
                GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "需要先创建或导入钱包".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "首页弹窗1".toMultilingualism(), leftButton: "home_after_button".toMultilingualism(), rightButton: "home_gonow_button".toMultilingualism()).subscribe(onNext: { index in                    if index == 1 {
                        tabBarController.selectedIndex = 1
                    }
                }).disposed(by: rx.disposeBag)
            }
        }
    }
    
    func checkFaceId() {
        
        if let isOpenLock = AppArchiveder.shared().mmkv?.bool(forKey: ArchivedKey.screenLock.rawValue), isOpenLock {
            if let timeStr = UserDefaults.standard.string(forKey: ArchivedKey.lastLockTime.rawValue), let lastTime = timeStr.toDate(style: .custom("yyyy-MM-dd HH:mm:ss")) {
                let endTime = lastTime + LockManager.shareInstance.currentItem.value.minutes
                if endTime.isInPast && !(AppDelegate.topViewController() is ScanViewController) {
                    let faceIdVC: FaceIDViewController = ViewLoader.Xib.controller()
                    faceIdVC.modalPresentationStyle = .fullScreen
                    AppDelegate.topViewController()?.present(faceIdVC, animated: true)
                    let time = Date().string(format: "yyyy-MM-dd HH:mm:ss")
                    UserDefaults.standard.setValue(time, forKeyPath: ArchivedKey.lastLockTime.rawValue)
                    UserDefaults.standard.synchronize()
                }
            }
        }
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
        
        tabBarViewController.delegate = self
        setupWindow()
        
        LocaleWalletManager.shared()
        checkFaceId()
        setupObserver()
        autoLogin()
        fetchAPPConfig()
        fetchContactServiceInfo()
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
        
        UIApplication.shared.rx.applicationWillResignActive.subscribe(onNext: { _ in
            
            let time = Date().string(format: "yyyy-MM-dd HH:mm:ss")
            UserDefaults.standard.setValue(time, forKeyPath: ArchivedKey.lastLockTime.rawValue)
            UserDefaults.standard.synchronize()
            
        }).disposed(by: rx.disposeBag)
    }
    
    func autoLogin() {
        LocaleWalletManager.shared().autoLogin()
    }
    
    func fetchAPPConfig() {
        let req: Observable<[AppSystemConfigModel]> = APIProvider.rx.request(.systemConfigFind).mapModelArray()
        req.subscribe(onNext: { list in
            AppArchiveder.shared().setupAppConfigs(data: list)
        }).disposed(by: rx.disposeBag)
    }
    
    func fetchContactServiceInfo() {
        APIProvider.rx.request(.contactService).mapJSON().subscribe(onSuccess: {[weak self] obj in
            let dict = obj as? [String: Any]
            self?.serviceInfo = dict?["data"] as? String
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
