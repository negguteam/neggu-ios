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
    case login(socialType: SocialType, socialID: String, fcmToken: String)
    case updateInfo(nickname: String)
    case checkNickname(nickname: String)
}

extension AuthAPI: BaseAPI {
    
    static var apiType: APIType = .auth
    
    var path: String {
        switch self {
        case .login:
            "/login"
        case .updateInfo:
            ""
        case .checkNickname:
            "/check-nickname"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login:
            return HeaderType.json.value
        default:
            return HeaderType.jsonWithToken.value
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNickname: .get
        case .updateInfo: .patch
        default: .post
        }
    }
    
    private var bodyParameters: Parameters {
        var params: Parameters = [:]
        
        switch self {
        case .login(let socialType, let socialID, let fcmToken):
            params = ["social_type": socialType.rawValue,
                      "social_id": socialID,
                      "os": "ios",
                      "app_version": Util.appVersion,
                      "device_id": Util.deviceID,
                      "fcm_token": fcmToken]
        case .updateInfo(let nickname):
            params = ["nickname": nickname]
        case .checkNickname(let nickname):
            params = ["nickname": nickname]
        }
        
        return params
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default: JSONEncoding.default
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkNickname:
            return .requestParameters(parameters: bodyParameters, encoding: URLEncoding.queryString)
        default:
            return .requestParameters(parameters: bodyParameters, encoding: parameterEncoding)
        }
    }
    
}
