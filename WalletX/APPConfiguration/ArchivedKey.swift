//
//  ArchivedKey.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import Foundation
import MMKV

enum ArchivedKey: String{
    case language
    case screenLock
    case currentWalletIndex
    case walletList
}

final class AppArchiveder {
    
    @discardableResult
    static func shared() -> AppArchiveder {
        return AppArchiveder.instance
    }
    
    private static let instance = AppArchiveder()
    
    private(set) var mmkv: MMKV?
    
    private init() {
        MMKV.initialize(rootDir: nil, logLevel: .none)
        MMKV.enableAutoCleanUp(maxIdleMinutes: 10)
        let cryptKey = "WalletX-mmkv-Encrypt-Key".data(using: .utf8)
        let mmapId = "WalletAPP"
        mmkv = MMKV(mmapID: mmapId, cryptKey: cryptKey)
    }
}



extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
