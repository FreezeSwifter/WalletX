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


final class LocaleWalletManager {
    
    @discardableResult
    static func shared() -> LocaleWalletManager {
        return LocaleWalletManager.instance
    }
    
    var hasWallet: Bool {
        return currentWallet != nil
    }
    
    var walletDidChanged: Observable<Void?> {
        return walletDidChangedSubject.asObservable().skip { o in
            return o == nil
        }
    }
    
    private static let instance = LocaleWalletManager()
    private(set) var currentWallet: HDWallet?
    private(set) var addressTRON: String?
    private(set) var addressUSDT: String?
    private let usdtContractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"
    private let walletDidChangedSubject: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    private var wallets: [WalletModel] = []
    var currentWalletModel: WalletModel? {
        let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue) ?? 0
        return wallets[Int(currentIndex)]
    }
    
    private init() {
        
        if let walletList = fetchLocalWalletList() {
            let currentIndex = AppArchiveder.shared().mmkv?.int32(forKey: ArchivedKey.currentWalletIndex.rawValue) ?? 0
            let tempCurrentWalletModel = walletList[Int(currentIndex)]
            currentWallet = HDWallet(mnemonic: tempCurrentWalletModel.mnemoic, passphrase: "")
            walletDidChangedSubject.onNext(())
            wallets = walletList
        }
        
        addressTRON = currentWallet?.getAddressForCoin(coin: .tron)
        if let tron = addressTRON {
            addressUSDT = "\(usdtContractAddress)-\(tron)"
        }
        //        let derivationPath = DerivationPath(purpose: .bip44, coin: CoinType.tron.rawValue, account: 0, change: 0, address: 0)
        //        let trxPrivateKey = currentWallet?.getKey(coin: .tron, derivationPath: derivationPath.description)
        //        let tronPublicKey = trxPrivateKey!.getPublicKeySecp256k1(compressed: true)
        //        let usdtAddress = AnyAddress(publicKey: publicKey, coin: .tron)
        
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
            let array = [WalletModel(name: "Wallet0", mnemoic: newMnemoic)]
            wallets = array
        }
        
        currentWallet = wallet
        addressTRON = currentWallet?.getAddressForCoin(coin: .tron)
        if let tron = addressTRON {
            addressUSDT = "\(usdtContractAddress)-\(tron)"
        }
        return newMnemoic
    }
    
    
    func save() {
        if let jsonData = try? JSONEncoder().encode(wallets) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                AppArchiveder.shared().mmkv?.set(jsonString, forKey: ArchivedKey.walletList.rawValue)
                walletDidChangedSubject.onNext(())
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
        AppArchiveder.shared().mmkv?.set(Int32(index), forKey: ArchivedKey.walletList.rawValue)
        guard let list = fetchLocalWalletList(), list.count != 0 else { return }
        let currentModel = list[index]
        currentWallet = HDWallet(mnemonic: currentModel.mnemoic, passphrase: "")
        walletDidChangedSubject.onNext(())
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
        addressTRON = nil
        addressUSDT = nil
        wallets = []
    }
    
    func updateWalletModel(model: WalletModel) {
        if let updateIndex = wallets.firstIndex(where: { item in
            return model.mnemoic == item.mnemoic
        }) {
            wallets[updateIndex] = model
            save()
        }
    }
    
    func getTRONAccount() async throws -> [String: Any]? {
        let tronAddress = addressTRON ?? ""
        let tronURL = "https://api.shasta.trongrid.io/wallet/getaccount"
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "accept": "application/json"
        ]
        let parameters: [String: Any] = [
            "address": "TZ4UXDV5ZhNW7fb2AMSbgfAEZ7hWsnYS2g",
            "visible": true
        ]
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(tronURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Empty.self) { response in
                
                switch response.result {
                case .success:
                    if let data = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: Any] {
                        continuation.resume(returning: data)
                    } else {
                        let error = NSError(domain: "ResponseError", code: 0, userInfo: nil)
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


struct WalletModel: Codable {
    var name: String
    let mnemoic: String
}
