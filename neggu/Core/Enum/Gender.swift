//
//  Gender.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable, Decodable {
    case MALE
    case FEMALE
    case UNKNOWN
    
    var id: String { "\(self)" }
    
    var title: String {
        switch self {
        case .MALE: "남성"
        case .FEMALE: "여성"
        default: ""
        }
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
    
    init(from decoder: Decoder) throws {
        self = try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
}
