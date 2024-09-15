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
            base += "/accounts"
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
}

enum HeaderType {
    case json
    case jsonWithToken
    case multipartWithToken
    
    public var value: [String: String] {
        switch self {
        case .json:
            return ["Content-Type": "application/json"]
        case .jsonWithToken:
            return ["Content-Type": "application/json",
                    "Authorization": UserDefaultsManager.accountToken ?? ""]
        case .multipartWithToken:
            return ["Content-Type": "multipart/form-data",
                    "Authorization": UserDefaultsManager.accountToken ?? ""]
        }
    }
}
