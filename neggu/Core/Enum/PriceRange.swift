//
//  PriceRange.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

enum PriceRange: String, CaseIterable, Codable {
    case UNKNOWN = "잘 모르겠어요"
    case UNDER_3K = "3만원 이하"
    case UNDER_5K = "5만원 이하"
    case FROM_5K_TO_10K = "5~10만원"
    case FROM_10K_TO_20K = "10~20만원"
    case FROM_20K_TO_30K = "20~30만원"
    case ABOVE_30K = "30만원 이상"
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
    
    init(from decoder: Decoder) throws {
        self = try PriceRange(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
}
