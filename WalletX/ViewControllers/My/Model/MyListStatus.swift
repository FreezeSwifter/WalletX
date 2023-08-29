//
//  MyListStatus.swift
//  WalletX
//
//  Created by DZSB-001968 on 28.8.23.
//

import Foundation

enum MyListStatus {
    case pending
    case depositing
    case guaranteeing
    case releasing
    case released
}


enum OrderOperationGuarantee {
    case applyRelease
    case revoke
    case handling
    
    var title: String {
        switch self {
        case .applyRelease:
            return "申请解押".toMultilingualism()
        case .revoke:
            return "撤销申请".toMultilingualism()
        case .handling:
            return "处理解押".toMultilingualism()
        }
    }
}

