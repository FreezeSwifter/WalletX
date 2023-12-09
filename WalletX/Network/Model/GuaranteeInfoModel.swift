//
//  GuaranteeInfoModel.swift
//  WalletX
//
//  Created by DZSB-001968 on 11.9.23.
//

import Foundation
import HandyJSON


struct GuaranteeInfoModel: APPBaseModel {
    
    
    struct Meta: HandyJSON {
        
        var id: String?
        var assureId: String? // 担保id
        var amount: Double?
        var pushAmount: Double?
        var releaseAmount: Double?
        var custodyAmount: Double?
        var sponsorUser: String? // 发起人walletId
        var sponsorAmount: Double?
        var pushDecimalSponsor: String?
        var partnerUser: String?
        var partnerUserName: String?
        var partnerAmount: Double?
        var pushDecimalPartner: String?
        var agreement: String? // 担保协议
        var agreeFlag: Int?
        var assureType: Int?
        var hc: String?
        var hcAddr: String?
        var createTime: Double?
        var assureStatus: Int?
        var pushAddr: String?
        var multisigStatus: Int?
        var multisigId: String?
        var multisigTime: Double?
        var chainCheck: Int?
        var checkTime: Double?
        var assureFee: Double?
        var releaseQueryTime: Double?
        var releaseSponsorUser: String?
        var finalTime: Double?
        var walletId: String?
        var pushWaitAmount: Double?
        var pushAddress: String?
        var pushAddressQrCode: String?
        var sponsorUserName: String?
        var duration: String?
        var releaseAmountCan: Double?
        var multisigAddress: String?
        var reason: Int?
        var sponsorReleasedAmount: Double?
        var partnerReleasedAmount: Double?
        var arbitrate: Int?
        var hcPay: Int?
        
        
        func assureTypeToString() -> String {
            switch assureType {
            case 0:
                return "普通担保".toMultilingualism()
            case 1:
                return "多签担保".toMultilingualism()
            default:
                return ""
            }
        }
    }
    
    
    var code: Int?
    
    var message: String?
    
    var data: Meta?
}
