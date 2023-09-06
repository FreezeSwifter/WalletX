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

