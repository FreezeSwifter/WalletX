//
//  NetworkManager.swift
//  WalletX
//
//  Created by DZSB-001968 on 6.9.23.
//

import Foundation
import Moya
import Alamofire

private var requestTimeOut: Double = 30

private let endpointClosure = { (target: NetworkService) -> Endpoint in
    let url = (target.baseURL.absoluteString + target.path).removingPercentEncoding!
    return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

private let networkPlugin1 = NetworkActivityPlugin { (changeType, targetType) in
    switch(changeType){
    case .began:
        print("开始请求网络")
    case .ended:
        print("结束")
    }
}

private let networkPlugin2: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))

private var MySesscion: Session {
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Session.default.sessionConfiguration.headers.dictionary
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    configuration.requestCachePolicy = .useProtocolCachePolicy
    return Session(configuration: configuration)
}

let APIProvider = MoyaProvider<NetworkService>(endpointClosure: endpointClosure, session: MySesscion, plugins: [networkPlugin1, networkPlugin2])
