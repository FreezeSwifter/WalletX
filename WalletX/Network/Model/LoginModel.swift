//
//  LoginModel.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import HandyJSON

struct LoginModel: APPBaseModel {
    
    struct Meta: HandyJSON {
        var walletId: String?
        var token: String?
        var nickName: String?
        var avatarAddress: String?
        var userId: String?
    }
    
    var code: Int?
    
    var message: String?
    
    var data: Meta?
    
    
}
