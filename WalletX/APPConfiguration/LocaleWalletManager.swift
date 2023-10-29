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
        let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue) ?? 0
        if wallets.isEmpty {
            return nil
        } else {
            return wallets[Int(currentIndex)]
        }
    }
    
    private static let instance = LocaleWalletManager()
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
    private let usdtContractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"
    private let walletDidChangedSubject: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    private var wallets: [WalletModel] = []
    private(set) var userInfo: UserInfoModel?
    private(set) var walletBalanceModel: TokenModel?
    private let walletBalanceSubject: BehaviorSubject<TokenModel?> = BehaviorSubject(value: nil)
    private let disposeBag = DisposeBag()
    private let tronWeb = TronWeb3()
    
    private init() {
        
        if let walletList = fetchLocalWalletList() {
            let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue) ?? 0
            let tempCurrentWalletModel = walletList[Int(currentIndex)]
            currentWallet = HDWallet(mnemonic: tempCurrentWalletModel.mnemoic, passphrase: "")
            walletDidChangedSubject.onNext(())
            wallets = walletList
        }
        
        TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
        USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.fetchUserData()
            self.fetchWalletBalanceData()
        })
        
        if tronWeb.isGenerateTronWebInstanceSuccess != true {
            if let privateKeyData = currentWallet?.getKeyForCoin(coin: .tron) {
                tronWeb.setup(privateKey: privateKeyData.data.toHexString(), node: TRONMainNet) { setupResult in
                    print(setupResult)
                }
            }
        }
    }
    
    func importWallet(mnemonic: String, walletName: String) -> Bool {
        let res = HDWallet.isValid(mnemonic: mnemonic)
        if res {
            currentWallet = HDWallet(mnemonic: mnemonic, passphrase: "")
            wallets.append(WalletModel(name: walletName, mnemoic: mnemonic))
            save()
            walletDidChangedSubject.onNext(())
        }
        return res
    }
    
    func createWallet() -> String {
        let wallet = HDWallet(strength: 128, passphrase: "")
        let newMnemoic = wallet.mnemonic
        
        if var originalArray = fetchLocalWalletList() {
            let walletModel = WalletModel(name: "Wallet\(originalArray.count - 1)", mnemoic: newMnemoic)
            originalArray.append(walletModel)
            wallets = originalArray
            
        } else {
            let array = [WalletModel(name: "Wallet", mnemoic: newMnemoic)]
            wallets = array
        }
        
        currentWallet = wallet
        TRON = .tron(currentWallet?.getAddressForCoin(coin: .tron))
        USDT = .usdt(currentWallet?.getAddressForCoin(coin: .tron))
        
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
        currentWallet = HDWallet(mnemonic: currentModel.mnemoic, passphrase: "")
        walletDidChangedSubject.onNext(())
        fetchUserData()
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
            AppArchiveder.shared().mmkv?.removeValue(forKey: ArchivedKey.currentWalletIndex.rawValue)
            cleanNotFinishedProcess()
            walletDidChangedSubject.onNext(())
        } else {
            
            if let jsonData = try? JSONEncoder().encode(list) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    AppArchiveder.shared().mmkv?.set(jsonString, forKey: ArchivedKey.walletList.rawValue)
                }
            }
        }
        wallets = list
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
    func fetchUserData() {
        let getUserInfoReq: Observable<UserInfoModel?> = APIProvider.rx.request(.getUserInfo).mapModel()
        getUserInfoReq.subscribe(onNext: {[weak self] obj in
            self?.userInfo = obj
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
    func sendToken(toAddress: String, amount: Int64, coinType: WalletToken) {
       
        if coinType == .tron(nil) {
            // 1 This value is 0.000001
            let amountText = amount * 100000
            tronWeb.trxTransfer(toAddress: toAddress, amount: amountText.description) { [weak self] (state, txid) in
                guard let self = self else { return }
                print("state = \(state)")
                print("txid = \(txid)")
            }
            
        } else {
            let amountText = amount.description
            tronWeb.trc20TokenTransfer(toAddress: toAddress, trc20ContractAddress: usdtContractAddress, amount: amountText, remark: "") { [weak self] (state, txid) in
                guard let self = self else { return }
                print("state = \(state)")
                print("txid = \(txid)")
            }
        }
    }
}


struct WalletModel: Codable {
    var name: String
    let mnemoic: String
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
            return "Tether"
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

