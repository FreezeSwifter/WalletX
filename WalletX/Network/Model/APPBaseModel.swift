//
//  APPBaseModel.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import HandyJSON

protocol APPBaseModel: HandyJSON {
    
    associatedtype T
    
    var code: Int? { get set }
    var message: String? { get set }
    var data: T? { set  get }
}


final class AppSystemConfigModel: NSObject, NSCoding, HandyJSON {
    
    var key: String?
    var value: String?
    
    required override init() {}
    
    func encode(with coder: NSCoder) {
        coder.encode(key, forKey: "key")
        coder.encode(value, forKey: "value")
    }
    
    init?(coder: NSCoder) {
        key = coder.decodeObject(forKey: "key") as? String
        value = coder.decodeObject(forKey: "value") as? String
    }
}

struct TokenModel: APPBaseModel {
    
    struct Meta: HandyJSON {
        var USDT: String?
        var TRX: String?
    }
    
    var code: Int?
    
    var message: String?
    
    var data: Meta?
}

struct TokenTecordTransferModel: HandyJSON {
    
    var id: Int64?
    var txid: String?
    var contract: String?
    var from: String?
    var to: String?
    var amount: Double?
    var blockNum: Int64?
    var createTime: Double?
}
