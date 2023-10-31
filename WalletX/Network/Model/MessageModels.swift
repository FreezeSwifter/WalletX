//
//  MessageModels.swift
//  WalletX
//
//  Created by DZSB-001968 on 29.10.23.
//

import Foundation
import HandyJSON

struct MessageListModel: HandyJSON {
    var id: String?
    var type: Int! // 消息类型，0:担保消息，1:钱包消息，2：平台公告
    var walletId: String?
    var icon: String?
    var content: String?
    var status: Int? // 消息状态，0:未读，1:已读
    var createTime: Int64?
    
    func displayType() -> String? {
        switch type {
        case 0:
            return "担保消息".toMultilingualism()
        case 1:
            return "钱包消息".toMultilingualism()
        case 2:
            return "平台公告".toMultilingualism()
        default:
            return nil
        }
    }
    
    func displayIcon() -> String {
        switch type {
        case 0:
            return "message_guarantee"
        case 1:
            return "message_wallet"
        case 2:
            return "message_system"
            
        default:
            return ""
        }
    }
}

struct MessageDetailModel: HandyJSON {
    var id: Int?
    var type: Int?
    var walletId: String?
    var content: String?
    var createTime: Int64?
}
