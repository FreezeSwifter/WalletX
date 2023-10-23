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
            let code = dict?["code"] as? Int ?? 0
            let error = dict?["message"] as? String ?? "Error"
            if code != 0 {
                throw NSError.init(domain: "https://appservice.usdtsure.com", code: code, userInfo: ["errorMsg": error])
            }
            
            if let nonEmpty = res {
                return .just(nonEmpty)
            } else {
                return .just([])
            }
        }.asObservable()
    }
    
    func mapDoubleValue() -> Observable<Double?> {
        
        return mapJSON().flatMap { obj in
            let dict = obj as? [String: Any]
            let value = dict?["data"] as? Double
            return .just(value)
        }.asObservable()
    }
    
    func mapStringValue() -> Observable<String?> {
        
        return mapJSON().flatMap { obj in
            let dict = obj as? [String: Any]
            let value = dict?["data"] as? String
            return .just(value)
        }.asObservable()
    }
}
