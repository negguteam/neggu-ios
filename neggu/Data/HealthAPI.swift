//
//  HealthAPI.swift
//  neggu
//
//  Created by 유지호 on 1/3/25.
//

import Foundation
import Alamofire
import Moya

enum HealthAPI {
    case unknownError
    case knownError
    case normal
}

extension HealthAPI: BaseAPI {
    
    static var apiType: APIType = .health
    
    var path: String {
        switch self {
        case .unknownError:
            "unknown-error"
        case .knownError:
            "known-error"
        case .normal:
            ""
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return HeaderType.json.value
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: .get
        }
    }
    
    private var parameterEncoding: ParameterEncoding {
        switch self {
        default: JSONEncoding.default
        }
    }
    
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
}
