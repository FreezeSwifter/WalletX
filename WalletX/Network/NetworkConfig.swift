//
//  NetworkConfig.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import Moya

enum NetworkService {
    case login(walletAddr: String)
    case banner(type: Int) // 0 首页banner 1 钱包banner
    case guaranteeDisplayData // 担保笔数,担保金额
    case serviceCategory // 商户分类
    case serviceList(categoryId: String) // 根据分类获取列表
    case userInfoSetting(info: [String: Any])
    case getUserInfo // 查询用户信息
    case getFeeforMultipleSignatures // 获取多签手续费
    case getSignaturesAddress(type: Int) // 获取收款地址 0多签, 1普通签
    case assureOrderLaunch(parameter: [String: Any]) // 发起担保
    case getWaitJoinInfo(assureId: String) // 查询待加入担保信息
    case assureOrderJoin(assureId: String, agreeFlag: Bool) // 加入协议
    case queryContactInfo(walletId: String) // 查询联系方式

}

extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "https://appservice.usdtsure.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/user/login"
        case .banner:
            return "/api/banner/list"
        case .guaranteeDisplayData:
            return "/api/assureOrder/dataIndex"
        case .serviceCategory:
            return "/api/merchant/category"
        case .serviceList:
            return "/api/merchant/service/list"
        case .userInfoSetting:
            return "/api/user/other/install"
        case .getUserInfo:
            return "/api/user/info"
        case .getFeeforMultipleSignatures:
            return "/api/assureOrder/hc"
        case .assureOrderLaunch:
            return "/api/assureOrder/launch"
        case .getSignaturesAddress:
            return "/api/collection/account/info"
        case .getWaitJoinInfo:
            return "/api/assureOrder/waitJoinInfo"
        case .assureOrderJoin:
            return "/api/assureOrder/join"
        case .queryContactInfo:
            return "/api/user/contactInfo"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        let requestParameters = parameters ?? [:]
        let encoding: ParameterEncoding = JSONEncoding.default
    
        let object = encrypted(json: requestParameters)
        let encryptedParameters = [
            "object": object ?? "",
            "sign": ""
        ]
        
        switch self {
        default:
            return .requestParameters(parameters: encryptedParameters, encoding: encoding)
        }
    }
    
    var headers: [String : String]? {
        var dict: [String: String] = ["Content-type": "application/json"]
        
        guard let addressKey = LocaleWalletManager.shared().TRON?.address?.md5() else {
            return dict
        }
        
        guard let loginModelString = AppArchiveder.shared().mmkv?.string(forKey: addressKey) else {
            return dict
        }
        
        let model = LoginModel.deserialize(from: loginModelString)
        guard let token = model?.data?.token else {
            return dict
        }
        
        dict.updateValue(token, forKey: "Authorization")
        return dict
    }
    
    private var parameters: [String: Any]? {
        switch self {
        case let .login(walletAddr):
            let dict: [String: Any] = ["walletAddr": walletAddr, "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "", "model": UIDevice.current.model]
            return dict
            
        case let .banner(type):
            return ["type": "\(type)"]
            
        case let .serviceList(categoryId):
            return ["categoryId": categoryId]
            
        case let .userInfoSetting(info):
            return info
            
        case let .assureOrderLaunch(parameter):
            return parameter
            
        case let .getSignaturesAddress(type):
            return ["type": type]
            
        case let .getWaitJoinInfo(assureId):
            return ["assureId": assureId]
            
        case let .assureOrderJoin(assureId, agreeFlag):
            return ["assureId": assureId, "agreeFlag": agreeFlag]
            
        case let .queryContactInfo(walletId):
            return ["walletId": walletId]
            
        default:
            return nil
        }
    }
    
    private func encrypted(json: [String: Any]?) -> String? {
        guard let dict = json else {
            return nil
        }
        let key = "688olPLkcxPq6K9F"
        let iv = "Qkmhd9EWIxUIQ2TE"
        do {
            let aes = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs5)
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let encryptedBytes = try aes.encrypt(jsonData.bytes)
            return encryptedBytes.toBase64()
            
        } catch let error {
            print(error)
            return nil
        }
    }
    
}
