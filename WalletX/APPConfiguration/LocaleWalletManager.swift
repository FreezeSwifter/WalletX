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
        return walletDidChangedSubject.asObservable().skip { entity in
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
    private(set) var currentWallet: HDWallet?
    private(set) var TRON: WalletToken? = .tron(nil)
    private(set) var USDT: WalletToken? = .usdt(nil)
    private let usdtContractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"
    private let walletDidChangedSubject: BehaviorSubject<Void?> = BehaviorSubject(value: nil)
    private var wallets: [WalletModel] = []
    private(set) var userInfo: UserInfoModel?
    private let disposeBag = DisposeBag()
    
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
            let getUserInfoReq: Observable<UserInfoModel?> = APIProvider.rx.request(.getUserInfo).mapModel()
            
            getUserInfoReq.subscribe(onNext: {[weak self] obj in
                self?.userInfo = obj
            }).disposed(by: self.disposeBag)
        })
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
    
    // 获取trx数量
    func getTRONBalance() async throws -> Double? {
        let tronURL = "https://api.shasta.trongrid.io/wallet/getaccount"
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "accept": "application/json"
        ]
        var parameters: [String: Any] = [
            "visible": true
        ]
        guard let address = TRON?.address else {
            return nil
        }
        parameters.updateValue(address, forKey: "address")
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(tronURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: Empty.self) { response in
                
                switch response.result {
                case .success:
                    if let data = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: Any] {
                        
                        let tokenBalance = data["balance"] as? Int64
                        let formattedBalance = Double(tokenBalance ?? 0)
                        continuation.resume(returning: formattedBalance)
                    } else {
                        let error = NSError(domain: "ResponseError", code: -113, userInfo: nil)
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func getUSDTBalance() async throws -> Double? {
        
        guard let address = USDT?.address else {
            return nil
        }
        
        let url = "https://api.shasta.trongrid.io/accounts/\(address)"
        let headers: HTTPHeaders = [
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            
            AF.request(url, method: .get, headers: headers).responseDecodable(of: Empty.self) { response in
                
                switch response.result {
                case .success:
                    if let data = try? JSONSerialization.jsonObject(with: response.data ?? Data(), options: []) as? [String: Any] {
                        
                        
                        continuation.resume(returning: 0.00)
                    } else {
                        let error = NSError(domain: "ResponseError", code: -113, userInfo: nil)
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func activationAccount() {
        
        guard let address = TRON?.address else {
            return
        }
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        let parameters = [
            "owner_address": "TZ4UXDV5ZhNW7fb2AMSbgfAEZ7hWsnYS2g",
            "account_address": address,
            "visible": true
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.shasta.trongrid.io/wallet/createaccount")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData ?? Data()
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let data = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                    print(data)
                }
            }
        })
        dataTask.resume()
    }
    
    private func broadcastTransaction(jsonString: String) {
        
        guard let data = jsonString.data(using: .utf8, allowLossyConversion: false) else { return }
        let parameters = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json"
        ]
        let postData = try? JSONSerialization.data(withJSONObject: parameters ?? "", options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.shasta.trongrid.io/wallet/broadcasttransaction")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData ?? Data()
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                if let data = try? JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                    print(data)
                }
            }
        })
        dataTask.resume()
    }
    
    func sendToken(toAddress: String, amount: Int64, coinType: WalletToken) {
        guard let w = currentWallet, let myAddress = TRON?.address else { return }
        let privateKey = w.getKeyForCoin(coin: .tron)
        
        if coinType == .tron("") {
            let signerInput = TronSigningInput.with {
                $0.privateKey = privateKey.data
                $0.transaction = TW_Tron_Proto_Transaction.with {
                    $0.transfer = TW_Tron_Proto_TransferContract.with {
                        $0.toAddress = toAddress
                        $0.amount = amount
                        $0.ownerAddress = myAddress
                    }
                }
            }
            
            let output: TronSigningOutput = AnySigner.sign(input: signerInput, coin: .tron)
            print(" data:   ", output.json)
            broadcastTransaction(jsonString: output.json)
            
        } else {
            
            let signerInput = TronSigningInput.with {
                $0.privateKey = privateKey.data
                $0.transaction = TW_Tron_Proto_Transaction.with {
                    $0.transferTrc20Contract = TW_Tron_Proto_TransferTRC20Contract.with {
                        $0.contractAddress = self.usdtContractAddress
                        $0.ownerAddress = myAddress
                        $0.toAddress = toAddress
                        let data = withUnsafeBytes(of: amount.bigEndian) { Data($0) }
                        $0.amount = data
                    }
                }
            }
            let output: TronSigningOutput = AnySigner.sign(input: signerInput, coin: .tron)
            print(" data:   ", output.json)
            broadcastTransaction(jsonString: output.json)
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
}

