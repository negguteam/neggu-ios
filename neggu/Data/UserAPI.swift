//
//  UserAPI.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import Foundation
import Moya

enum UserAPI {
    case profile
    case logout
    case withdraw
}

extension UserAPI: BaseAPI {
    
    static var apiType: APIType = .user
    
    var path: String {
        switch self {
        case .profile:
            "/profile"
        case .logout:
            "/logout"
        case .withdraw:
            "/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile: .get
        case .logout: .post
        case .withdraw: .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logout:
                .requestParameters(
                    parameters: ["refreshToken": UserDefaultsKey.Auth.refreshToken ?? "none"],
                    encoding: JSONEncoding.default
                )
        default: .requestPlain
        }
    }
    
}
