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
}


extension NetworkService: TargetType {
    var baseURL: URL {
        return URL(string: "https://appservice.usdtsure.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/user/login"
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
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(walletAddr):
            let p: [String: Any] = ["walletAddr": walletAddr, "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "", "model": UIDevice.current.model]
            return p
        }
    }
    
    func encrypted(json: [String: Any]?) -> String? {
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
