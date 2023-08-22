//
//  ArchivedKey.swift
//  WalletX
//
//  Created by DZSB-001968 on 22.8.23.
//

import Foundation

enum ArchivedKey: String{
    case language
    case screenLock
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}

