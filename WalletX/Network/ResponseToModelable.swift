//
//  ResponseToModelable.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import HandyJSON
import RxCocoa
import RxSwift
import Moya


public extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    
    func mapModel<T: HandyJSON>() -> Observable<T?> {
        
        return mapJSON().flatMap { obj in
            let dict = obj as? [String: Any]
            let model = T.deserialize(from: dict)
            return .just(model)
        }.asObservable()
    }
    
    func mapModelArray<T: HandyJSON>() -> Observable<[T]> {
        
        return mapJSON().flatMap { obj in
            let dict = obj as? [String: Any]
            let objList = dict?["data"] as? [[String: Any]]
            let res = [T].deserialize(from: objList)?.compactMap { $0 }
            if let nonEmpty = res {
                return .just(nonEmpty)
            } else {
                return .just([])
            }
        }.asObservable()
    }
}
