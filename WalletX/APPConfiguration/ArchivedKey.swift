//
//  ArchivedKey.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import Foundation
import MMKV


enum ArchivedKey: String {
    case language
    case screenLock
    case currentWalletIndex
    case walletList
    case ratePopup
    case appconfigs
    case autolock
    case lastLockTime
}

final class AppArchiveder {
    
    @discardableResult
    static func shared() -> AppArchiveder {
        return AppArchiveder.instance
    }
    
    private static let instance = AppArchiveder()
    
    private(set) var mmkv: MMKV?
    
    private(set) var appConfigs: [AppSystemConfigModel] = []
    
    private init() {
        MMKV.initialize(rootDir: nil, logLevel: .none)
        MMKV.enableAutoCleanUp(maxIdleMinutes: 10)
        let cryptKey = "WalletX-mmkv-Encrypt-Key".data(using: .utf8)
        let mmapId = "WalletAPP"
        mmkv = MMKV(mmapID: mmapId, cryptKey: cryptKey)
        
        if let localData = mmkv?.string(forKey: ArchivedKey.appconfigs.rawValue), let configs = [AppSystemConfigModel].deserialize(from: localData)?.compactMap({ $0 }) {
            appConfigs = configs
        }
    }
    
    func setupAppConfigs(data: [AppSystemConfigModel]) {
        appConfigs = data
        if let dataStr = data.toJSONString() {
            mmkv?.set(dataStr, forKey: ArchivedKey.appconfigs.rawValue)
        }
    }
    
    func getAPPConfig(by key: String) -> String? {
        return appConfigs.filter { $0.key == key }.first?.value
    }
}
 
extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
    static let orderDidChangeed = Notification.Name("orderDidChangeed")
    static let userInfoDidChangeed = Notification.Name("userInfoDidChangeed")
    static let loginSuccessful = Notification.Name("loginSuccessful")
    static let deviceDisabled = Notification.Name("deviceDisabled")
}
