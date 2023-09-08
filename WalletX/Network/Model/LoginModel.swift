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

struct UserInfoModel: APPBaseModel {
    
    struct Meta: HandyJSON {
        var id: Int64?
        var nickName: String?
        var headImage: String?
        var walletId: String?
        var walletAddr: String?
        var tg: String?
        var email: String?
        var lange: Int64?
        var creditLevel: Int64?
        var balanceUsdt: Double?
        var balanceTrx: Double?
        var inviteCode: String?
        var kyc: Int?
        var pin: Int?
        var status: Int?
        var createTime: Double?
        var loginFinalTime: Double?
        var loginNum: Int64?
        var terminal: String?
        var remark: String?
        var token: String?
        var assureFeeRemind: Int64?
    }
    
    var code: Int?
    
    var message: String?
    
    var data: Meta?
}
