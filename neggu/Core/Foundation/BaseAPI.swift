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
        return .customCodes(Array(200..<500))
    }
    
}

enum APIType {
    case auth
    case notification
    case health
}

enum HeaderType {
    case json
    case jsonWithToken
    case jsonWithRegisterToken
    case multipartWithToken
    
    public var value: [String: String] {
        switch self {
        case .json:
            ["Content-Type": "application/json"]
        case .jsonWithToken:
            ["Content-Type": "application/json",
             "Authorization": UserDefaultsKey.Auth.accessToken ?? "none"]
        case .jsonWithRegisterToken:
            ["Content-Type": "application/json",
             "RegisterToken": UserDefaultsKey.Auth.registerToken ?? "none"]
        case .multipartWithToken:
            ["Content-Type": "multipart/form-data",
             "Authorization": UserDefaultsKey.Auth.accessToken ?? "none"]
        }
    }
}
