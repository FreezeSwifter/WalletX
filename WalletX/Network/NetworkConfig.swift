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
    /*
     1, // 担保状态，0:待加入，1:待上押，2:担保中，3:已退押，4:已取消，5:加入超时，6:创建超时，7:上押超时，8:已删除，9:退押中
     */
    case queryAssureOrderList(assureStatus: Int?, pageNum: Int) // 查询担保列表
    case systemConfigFind // 查询系统配置
    case cancelGuarantee(assureId: String) // 取消担保
    case updateGuarantee(assureId: String, agreement: String) // 更新担保
    case deleteGuarantee(assureId: String) // 删除担保
    case getTokenLogo(token: String) // 获取币种logo
    case getWalletBalance // 获取钱包余额
    case getTokenTecordTransfer(pageNumber: Int, symbolID: String) // 获取转账记录
    case getAssureOrderDetail(assureId: String) // 查询订单信息
    case finiedOrder(assureId: String) // 完成上押
    case assureReleaseApply(assureId: String, reason: Int, sponsorReleasedAmount: String, partnerReleasedAmount: String) // 申请解押
    case revokeAssureApply(assureId: String) //撤销申请
    case releaseAgree(assureId: String, privateKey: String) // 同意解押
    case getTXInfo(txId: String) // 获取TX信息
    case messageList // 消息列表
    case readMessage(id: String) // 消息已读
    case messageDetail(id: Int) // 消息详情
    case contactService // 联系客服
    case appDownload // app下载地址
    case addressValidate(address: String) // 验证收款地址是否正确
    case arbitrateAccept(assureId: String, key: String) // 同意仲裁
    case releaseInfo(assureId: String) // 申请解押查询
    case assureOrderReleaseReject(assureId: String) // 拒绝解押
    case searchOrderList // 订单搜索接口
    case seendTokenConfirm(assureId: String, function: Int, txId: String, amount: String) // 转账确认订单
    case activeAssureOrder(assureId: String) // 激活订单
    case userTerminal // 查询设备是否禁用


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
        case .queryAssureOrderList:
            return "/api/assureOrder/list"
        case .systemConfigFind:
            return "/api/config/find"
        case .cancelGuarantee:
            return "/api/assureOrder/cancel"
        case .updateGuarantee:
            return "/api/assureOrder/modify"
        case .deleteGuarantee:
            return "/api/assureOrder/delete"
        case .getTokenLogo:
            return "/api/coin/image"
        case .getWalletBalance:
            return "/api/user/balance"
        case .getTokenTecordTransfer:
            return "/api/user/record/transfer"
        case .getAssureOrderDetail:
            return "/api/assureOrder/info"
        case .finiedOrder:
            return "/api/assureOrder/push"
        case .assureReleaseApply:
            return "/api/assureOrder/release/apply"
        case .revokeAssureApply:
            return "/api/assureOrder/release/cancel"
        case .releaseAgree:
            return "/api/assureOrder/release/agree"
        case .getTXInfo:
            return "/api/user/txInfo"
        case .messageList:
            return "/api/user/message/list"
        case .readMessage:
            return "/api/user/message/read"
        case .messageDetail:
            return "/api/user/message/detail"
        case .contactService:
            return "/api/config/customer"
        case .appDownload:
            return "/api/config/app/download"
        case .addressValidate:
            return "/api/user/address/validate"
        case .arbitrateAccept:
            return "/api/assureOrder/arbitrate/accept"
        case .releaseInfo:
            return "/api/assureOrder/release/info"
        case .assureOrderReleaseReject:
            return "/api/assureOrder/release/reject"
        case .searchOrderList:
            return "/api/assureOrder/pendingList"
        case .seendTokenConfirm:
            return "/api/assureOrder/transfer/confirm"
        case .activeAssureOrder:
            return "/api/assureOrder/active"
        case .userTerminal:
            return "/api/user/terminal"
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
        let languageValue = LanguageManager.shared().currentCode == .cn ? "0" : "1"
        dict.updateValue(languageValue, forKey: "lang")
        
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
            
        case let .queryAssureOrderList(assureStatus, pageNum):
            if let status = assureStatus {
                return ["assureStatus": status, "pageNum": pageNum, "pageSize": 10]
            } else {
                return ["pageNum": pageNum, "pageSize": 10]
            }
        
        case let .cancelGuarantee(assureId):
            return ["assureId": assureId]
            
        case let .updateGuarantee(assureId, agreement):
            return ["assureId": assureId, "agreement": agreement]
            
        case let .deleteGuarantee(assureId):
            return ["assureId": assureId]
            
        case let .getTokenLogo(token):
            return ["coin": token]
            
        case let .getAssureOrderDetail(assureId):
            return ["assureId": assureId]
            
        case let .finiedOrder(assureId):
            return ["assureId": assureId]
            
        case let .assureReleaseApply(assureId, reason, sponsorReleasedAmount, partnerReleasedAmount):
            let key = LocaleWalletManager.shared().currentWallet?.getKeyForCoin(coin: .tron).data.hexString ?? ""
            return ["assureId": assureId, "reason": reason, "sponsorReleasedAmount": sponsorReleasedAmount, "partnerReleasedAmount": partnerReleasedAmount, "pass": key]
            
        case let .revokeAssureApply(assureId):
            return ["assureId": assureId]
            
        case let .releaseAgree(assureId, privateKey):
            return ["assureId": assureId, "pass": privateKey]
            
        case let .getTokenTecordTransfer(pageNumber, symbolId):
            return ["pageNum": pageNumber, "pageSize": 10, "coin": symbolId]
            
        case let .getTXInfo(txId):
            return ["txId": txId]
            
        case let .readMessage(id):
            return ["id": id]
            
        case let .messageDetail(id):
            return ["type": id]
            
        case let .addressValidate(address):
            return ["address": address]
            
        case let .arbitrateAccept(assureId, key):
            return ["assureId": assureId, "pass": key]
            
        case let .releaseInfo(assureId):
            return ["assureId": assureId]
            
        case let .assureOrderReleaseReject(assureId):
            let key = LocaleWalletManager.shared().currentWallet?.getKeyForCoin(coin: .tron).data.hexString ?? ""
            return ["assureId": assureId, "pass": key]
            
        case let .seendTokenConfirm(assureId, function, txId, amount):
            return ["assureId": assureId, "function": function, "txId": txId, "amount": amount]
            
        case let .activeAssureOrder(assureId):
            return ["assureId": assureId]
            
        case .userTerminal:
            return ["deviceId": UIDevice.current.identifierForVendor?.uuidString ?? ""]
            
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
