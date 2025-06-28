//
//  InsightAPI.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Foundation
import Moya

public enum InsightAPI {
    case getInsight
}

extension InsightAPI: BaseAPI {
    
    public static var apiType: APIType = .insight
    
    public var path: String {
        switch self {
        default: ""
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default: HeaderType.jsonWithToken.value
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default: .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        default: .requestPlain
        }
    }
    
}
