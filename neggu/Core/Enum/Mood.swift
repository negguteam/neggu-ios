//
//  Mood.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

enum Mood: String, CaseIterable, Identifiable, Codable {
    case FEMININE
    case SPORTS
    case STREETWEAR
    case MODERN
    case VINTAGE
    case OUTDOOR
    case OFFICE
    case ETHNIC
    case PREPPY
    case LUXURY
    case CASUAL
    case AMERICAN
    case UNKNOWN
    
    var id: String { "\(self)" }
    
    var title: String {
        switch self {
        case .FEMININE: "페미닌"
        case .SPORTS: "스포츠"
        case .STREETWEAR: "스트릿"
        case .MODERN: "모던"
        case .VINTAGE: "빈티지"
        case .OUTDOOR: "아웃도어"
        case .OFFICE: "오피스"
        case .ETHNIC: "에스닉"
        case .PREPPY: "프레피"
        case .LUXURY: "럭셔리"
        case .CASUAL: "캐주얼"
        case .AMERICAN: "아메리칸"
        case .UNKNOWN: ""
        }
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
    
    init(from decoder: Decoder) throws {
        self = try Mood(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
}
