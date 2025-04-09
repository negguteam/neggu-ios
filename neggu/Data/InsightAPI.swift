//
//  InsightAPI.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Foundation
import Moya

enum InsightAPI {
    case getInsight
}

extension InsightAPI: BaseAPI {
    
    static var apiType: APIType = .insight
    
    var path: String {
        switch self {
        default: ""
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default: HeaderType.jsonWithToken.value
        }
    }
    
    var method: Moya.Method {
        switch self {
        default: .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        default: .requestPlain
        }
    }
    
}
