//
//  CategoryModel.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import HandyJSON


struct CategoryModel: HandyJSON, Equatable {
    var id: String?
    var category: String?
    
    static func ==(lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        return lhs.id == rhs.id && lhs.category == rhs.category
    }
}


struct ServiceListModel: HandyJSON {
    
    var id: Int?
    var walletId: String?
    var mertName: String?
    var logo: String?
    var categoryId: Int?
    var status: Int?
    var tg: String?
}
