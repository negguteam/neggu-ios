//
//  Gender.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

public enum Gender: String, CaseIterable, Identifiable, Decodable {
    case MALE
    case FEMALE
    case UNKNOWN
    
    public var id: String { "\(self)" }
    
    public var title: String {
        switch self {
        case .MALE: "남성"
        case .FEMALE: "여성"
        default: ""
        }
    }
    
    public static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
    
    public init(from decoder: Decoder) throws {
        self = try Gender(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
}
