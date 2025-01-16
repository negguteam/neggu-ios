//
//  BaseAPI.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}


extension BaseAPI {
    
    var baseURL: URL {
        var base = NegguEnv.Network.baseURL
        
        switch Self.apiType {
        case .auth:
            base += "/auth"
        case .closet:
            base += "/clothes"
        case .health:
            base += "/health"
        default:
            base += ""
        }
        
        guard let url = URL(string: base) else {
          fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    var headers: [String: String]? {
        return HeaderType.jsonWithToken.value
    }
    
    var validationType: ValidationType {
        return .customCodes(Array(200..<500).filter { $0 != 401 })
    }
    
}

enum APIType {
    case auth
    case closet
    case notification
    case health
}

enum HeaderType {
    case json
    case jsonWithRegisterToken
    case jsonWithToken
    case multipartWithToken
    
    public var value: [String: String] {
        switch self {
        case .json:
            ["Content-Type": "application/json"]
        case .jsonWithRegisterToken:
            ["Content-Type": "application/json",
             "RegisterToken": UserDefaultsKey.Auth.registerToken ?? "none"]
        case .jsonWithToken:
            ["Content-Type": "application/json",
             "Authorization": "Bearer \(UserDefaultsKey.Auth.accessToken ?? "none")"]
        case .multipartWithToken:
            ["Content-Type": "multipart/form-data",
             "Authorization": "Bearer \(UserDefaultsKey.Auth.accessToken ?? "none")"]
        }
    }
}
