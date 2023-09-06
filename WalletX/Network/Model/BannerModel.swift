//
//  BannerModel.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import HandyJSON

struct BannerModel: HandyJSON, Equatable {
    var imageUrl: String?
    var url: String?
    var sort: Int?
    
    static func ==(lhs: BannerModel, rhs: BannerModel) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.url == rhs.url && lhs.sort == rhs.sort
    }
}
