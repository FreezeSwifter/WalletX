//
//  LocaleWalletManager.swift
//  WalletX
//
//  Created by DZSB-001968 on 1.9.23.
//

import Foundation
import WalletCore
import RxCocoa
import RxSwift
import Alamofire
import TronWeb

final class LocaleWalletManager {
    
    @discardableResult
    static func shared() -> LocaleWalletManager {
        return LocaleWalletManager.instance
    }
    
    var hasWallet: Bool {
        return currentWallet != nil
    }
    
    var walletDidChanged: Observable<Void?> {
        return walletDidChangedSubject.asObservable().skip { entity in
            return entity == nil
        }
    }
    
    var walletBalance: Observable<TokenModel?> {
        return walletBalanceSubject.asObservable().skip { entity in
            return entity == nil
        }
    }
    
    var currentWalletModel: WalletModel? {
        
        if let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue), currentIndex >= 0 {
            if wallets.isEmpty {
                return nil
            } else {
                return wallets[Int(currentIndex)]
            }
        } else {
            return nil
        }
    }
    
    static let instance = LocaleWalletManager()
    private(set) var currentWallet: HDWallet? {
        didSet {
            if let key = currentWallet?.getKeyForCoin(coin: .tron) {
                tronWeb.tronWebResetPrivateKey(privateKey: key.data.toHexString()) { setupResult in
                    print(setupResult)
                }
            }
        }
    }
    private(set) var TRON: WalletToken? = .tron(nil)
    private(set) var USDT: WalletToken? = .usdt(nil)
//    TAwtf3SDKc3k4j5Pg6cs1cUngXuhzVbarT 测试网
//    TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t 主网
    // TEpkBH2Yb9NG3xgXUW6UbudakyuCHZ7ZVF n网合约地址
    private let usdtContractAddress = "TEpkBH2Yb9NG3xgXUW6UbudakyuCHZ7ZVF"
    private let walletDidChangedSubject: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    private var wallets: [WalletModel] = []
    private(set) var userInfo: UserInfoModel?
    private(set) var walletBalanceModel: TokenModel?
    private let walletBalanceSubject: BehaviorSubject<TokenModel?> = BehaviorSubject(value: nil)
    private let disposeBag = DisposeBag()
    private let tronWeb = TronWeb3()
    
    private init() {
        
        if let walletList = fetchLocalWalletList(), let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue), currentIndex >= 0 {
            let tempCurrentWalletModel = walletList[Int(currentIndex)]
            currentWallet = HDWallet(mnemonic: tempCurrentWalletModel.mnemoic ?? "", passphrase: "")
            walletDidChangedSubject.onNext(())
            wallets = walletList
        }
        
        TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
        USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
        
        if tronWeb.isGenerateTronWebInstanceSuccess != true {
            if let privateKeyData = currentWallet?.getKeyForCoin(coin: .tron) {
                tronWeb.setup(privateKey: privateKeyData.data.toHexString(), node: TRONNileNet) { setupResult in
                    print(setupResult)
                }
            }
        }
    }
    
    @discardableResult
    func importWallet(mnemonic: String, walletName: String) -> String? {
        let res = HDWallet.isValid(mnemonic: mnemonic)
        if res {
            if fetchLocalWalletList()?.contains(where: { $0.mnemoic == mnemonic }) ?? false {
                return "钱包已存在本地".toMultilingualism()
            } else {
                currentWallet = HDWallet(mnemonic: mnemonic, passphrase: "")
                TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
                USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
                fetchUserData(mnemonic: mnemonic, walletName: walletName)
                
                return nil
            }
            
        } else {
            return "助记词输入有误".toMultilingualism()
        }
    }
    
    func createWallet() -> String {
        let wallet = HDWallet(strength: 128, passphrase: "")
        let newMnemoic = wallet.mnemonic
        
        if var originalArray = fetchLocalWalletList() {
            let walletModel = WalletModel(name: nil, mnemoic: newMnemoic)
            originalArray.insert(walletModel, at: 0)
            wallets = originalArray
            
        } else {
            let array = [WalletModel(name: nil, mnemoic: newMnemoic, nickName: nil, walletId: nil)]
            wallets = array
        }
        
        currentWallet = wallet
        TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
        USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
        fetchUserData(mnemonic: newMnemoic, walletName: nil, isAdd: false, isSelected: true)
        
        return newMnemoic
    }
    
    
    func save(isNotActiveAccount: Bool = false) {
        if let jsonData = try? JSONEncoder().encode(wallets) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                AppArchiveder.shared().mmkv?.set(jsonString, forKey: ArchivedKey.walletList.rawValue)
                walletDidChangedSubject.onNext(())
                if isNotActiveAccount {
                    activationAccount()
                }
            }
        }
    }
    
    func fetchLocalWalletList() -> [WalletModel]? {
        guard let storedString = AppArchiveder.shared().mmkv?.string(forKey: ArchivedKey.walletList.rawValue), let jsonData = storedString.data(using: .utf8) else {
            return nil
        }
        let array = try? JSONDecoder().decode([WalletModel].self, from: jsonData)
        
        return array
    }
    
    func didSelectedWallet(index: Int) {
        AppArchiveder.shared().mmkv?.set(Int32(index), forKey: ArchivedKey.currentWalletIndex.rawValue)
        guard let list = fetchLocalWalletList(), list.count != 0 else { return }
        let currentModel = list[index]
        currentWallet = HDWallet(mnemonic: currentModel.mnemoic ?? "", passphrase: "")
        TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
        USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
        fetchUserData(mnemonic: nil, walletName: nil, isAdd: false, isSelected: true)
        fetchWalletBalanceData()
    }
    
    func deleteWalletModel(by model: WalletModel) {
        guard var list = fetchLocalWalletList() else {
            return
        }
        guard let deleteIndex = list.firstIndex(where: { item in
            return item.mnemoic == model.mnemoic
        }) else {
            return
        }
        list.remove(at: deleteIndex)
        
        if list.isEmpty {
            AppArchiveder.shared().mmkv?.removeValue(forKey: ArchivedKey.walletList.rawValue)
            AppArchiveder.shared().mmkv?.set(Int32(-1), forKey: ArchivedKey.currentWalletIndex.rawValue)
            cleanNotFinishedProcess()
            UIApplication.topViewController()?.navigationController?.popToRootViewController(animated: true)
        } else {
            
            if let jsonData = try? JSONEncoder().encode(list) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    AppArchiveder.shared().mmkv?.set(jsonString, forKey: ArchivedKey.walletList.rawValue)
                }
            }
        }
        wallets = list
        if let index = wallets.firstIndex(where: { m in
            return wallets.first?.mnemoic == m.mnemoic
        }) {
            AppArchiveder.shared().mmkv?.set(Int32(index), forKey: ArchivedKey.currentWalletIndex.rawValue)
        }
        
        fetchUserData(mnemonic: nil, walletName: nil, isAdd: false)
    }
    
    func cleanNotFinishedProcess() {
        currentWallet = nil
        TRON = nil
        USDT = nil
        wallets = []
    }
    
    func updateWalletModel(model: WalletModel, isNotActiveAccount: Bool = false) {
        if let updateIndex = wallets.firstIndex(where: { item in
            return model.mnemoic == item.mnemoic
        }) {
            wallets[updateIndex] = model
            save(isNotActiveAccount: isNotActiveAccount)
        }
    }
    
    // 获取账户余额
    func fetchWalletBalanceData() {
        let getWalletBalance: Observable<TokenModel?> = APIProvider.rx.request(.getWalletBalance).mapModel()
        getWalletBalance.subscribe(onNext: {[weak self] obj in
            self?.walletBalanceModel = obj
            self?.walletBalanceSubject.onNext(obj)
        }).disposed(by: disposeBag)
    }
    
    // 获取用户数据
    func fetchUserData(mnemonic: String?, walletName: String?, isAdd: Bool = true, isSelected: Bool = false) {
        
        func fetUserInfo() {
            let getUserInfoReq: Observable<UserInfoModel?> = APIProvider.rx.request(.getUserInfo).mapModel()
            getUserInfoReq.subscribe(onNext: {[unowned self] obj in
                userInfo = obj
                if isAdd {
                    var importOne = WalletModel(name: walletName, mnemoic: mnemonic, nickName: obj?.data?.nickName, walletId: obj?.data?.walletId)
                    wallets = wallets.map { m in
                        var nm = WalletModel(name: m.nickName, mnemoic: m.mnemoic, nickName: m.nickName, walletId: m.walletId)
                        nm.isSelected = false
                        return nm
                    }
                    importOne.isSelected = true
                    wallets.insert(importOne, at: 0)
                    AppArchiveder.shared().mmkv?.set(Int32(0), forKey: ArchivedKey.currentWalletIndex.rawValue)
                    
                } else {
                    if let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue), currentIndex >= 0 {
                        wallets = wallets.map { m in
                            var nm = WalletModel(name: m.name, mnemoic: m.mnemoic, nickName: m.nickName, walletId: m.walletId)
                            nm.isSelected = false
                            return nm
                        }
                        if wallets.isNotEmpty {
                            var one = wallets[Int(currentIndex)]
                            one.walletId = obj?.data?.walletId
                            one.name = obj?.data?.nickName
                            one.isSelected = isSelected
                            wallets[Int(currentIndex)] = one
                        }
                    }
                }
                save()
            }).disposed(by: disposeBag)
        }
        
        let loginReq: Observable<LoginModel?> = APIProvider.rx.request(.login(walletAddr: LocaleWalletManager.shared().TRON?.address ?? "")).mapModel()
        
        loginReq.subscribe(onNext: { model in
            guard let addressKey = LocaleWalletManager.shared().TRON?.address?.md5() else { return }
            guard let jsonString = model?.toJSONString() else { return }
            AppArchiveder.shared().mmkv?.set(jsonString, forKey: addressKey)
            NotificationCenter.default.post(name: .loginSuccessful, object: nil)
            fetUserInfo()
        }).disposed(by: disposeBag)
    }
    
    // 激活账户
    private func activationAccount() {
        
        guard let address = TRON?.address else {
            return
        }
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        let parameters = [
            "owner_address": address,
            "account_address": address,
            "visible": true
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.trongrid.io/wallet/createaccount")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData ?? Data()
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: {[weak self] (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let data = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                    print(data)
                    self?.walletDidChangedSubject.onNext(())
                }
            }
        })
        dataTask.resume()
    }
    
    // 发送token
    func sendToken(toAddress: String, amount: Double, coinType: WalletToken) -> Observable<(Bool, String)> {
       
        return Observable.create {[unowned self] o in
            
            if coinType == .tron(nil) {
                // 1 This value is 0.000001
                let amountText = amount * 1000000
                let num = Int64(amountText).description
                
                self.tronWeb.trxTransfer(toAddress: toAddress, amount: num) { (state, txid) in
                    o.onNext((state, txid))
                    o.onCompleted()
                    print("state = \(state)")
                    print("txid = \(txid)")
                }
                
            } else {
                let amountText = amount * 1000000
                let num = Int64(amountText).description
                
                self.tronWeb.trc20TokenTransfer(toAddress: toAddress, trc20ContractAddress: usdtContractAddress, amount: num, remark: "transfer") {(state, txid) in
                    o.onNext((state, txid))
                    o.onCompleted()
                    print("state = \(state)")
                    print("txid = \(txid)")
                }
            }
            
            return Disposables.create {}
        }
    }
    
    func autoLogin() {
        let req: Observable<LoginModel?> = APIProvider.rx.request(.login(walletAddr: LocaleWalletManager.shared().TRON?.address ?? "")).mapModel()
        req.subscribe(onNext: { model in
            guard let addressKey = LocaleWalletManager.shared().TRON?.address?.md5() else { return }
            guard let jsonString = model?.toJSONString() else { return }
            AppArchiveder.shared().mmkv?.set(jsonString, forKey: addressKey)
            NotificationCenter.default.post(name: .loginSuccessful, object: nil)
        }).disposed(by: disposeBag)
    }
}


struct WalletModel: Codable {
    var name: String?
    var mnemoic: String?
    var nickName: String?
    var walletId: String?
    var isSelected: Bool = false
}

enum WalletToken: Equatable {
    case tron(String?)
    case usdt(String?)
    
    var tokenName: String {
        switch self {
        case .tron:
            return "TRX"
        case .usdt:
            return "USDT"
        }
    }
    
    var address: String? {
        switch self {
        case .tron(let string):
            return string
        case .usdt(let string):
            return string
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .tron:
            return UIImage(named: "wallet_tron_icon")
        case .usdt:
            return UIImage(named: "wallet_usdt_icon")
        }
    }
    
    var companyName: String? {
        switch self {
        case .tron:
            return "Tron"
        case .usdt:
            return "Tron|TRC20"
        }
    }
    
    static func ==(lhs: WalletToken, rhs: WalletToken) -> Bool {
        
        switch (lhs, rhs) {
        case (.tron, .tron),
            (.usdt, .usdt):
            return true
        default:
            return false
        }
    }
}

extension LocaleWalletManager {
    static func checkLogin(callback: @escaping () -> Void) {
        if LocaleWalletManager.shared().currentWallet != nil {
            callback()
        } else {
            GuaranteeYesNoView.showFromBottom(image: UIImage(named: "guarantee_yes_no"), title: "需要先创建或导入钱包".toMultilingualism(), titleIcon: UIImage(named: "guarantee_bulb"), content: "首页弹窗1".toMultilingualism(), leftButton: "home_after_button".toMultilingualism(), rightButton: "home_gonow_button".toMultilingualism()).subscribe { index in
                if index == 1 {
                    let app = UIApplication.shared.delegate as? AppDelegate
                    app?.tabBarSelecte(index: 1)
                }
            }.disposed(by: LocaleWalletManager.shared().disposeBag)
        }
    }
}

