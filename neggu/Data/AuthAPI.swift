//
//  AuthAPI.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation
import Alamofire
import Moya

enum SocialType: String, Codable {
    case apple
    case google
    case kakao
}

enum AuthAPI {
    case login(socialType: SocialType, idToken: String)
    case register(parameters: Parameters)
    case checkNickname(nickname: String)
    case tokenReissuance
}

extension AuthAPI: BaseAPI {
    
    static var apiType: APIType = .auth
    
    var path: String {
        switch self {
        case .login(let socialType, _):
            "/login/\(socialType)"
        case .register:
            "/register"
        case .checkNickname:
            "/check/nickname"
        case .tokenReissuance:
            "/token"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .register:
            return HeaderType.jsonWithRegisterToken.value
        default:
            return HeaderType.json.value
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(_, let idToken):
                .requestParameters(
                    parameters: ["idToken": idToken],
                    encoding: JSONEncoding.default
                )
        case .register(let parameters):
                .requestParameters(
                    parameters: parameters,
                    encoding: JSONEncoding.default
                )
        case .checkNickname(let nickname):
                .requestParameters(
                    parameters: ["nickName": nickname],
                    encoding: JSONEncoding.default
                )
        case .tokenReissuance:
                .requestParameters(
                    parameters: ["refreshToken": UserDefaultsKey.Auth.refreshToken ?? "none"],
                    encoding: JSONEncoding.default
                )
        }
    }
    
}
