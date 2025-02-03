//
//  Category.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

enum Category: String, CaseIterable, Identifiable, Codable {
    case TOP
    case BOTTOM
    case OUTER
    case ONEPIECE
    case ACCESSORY
    case BAG
    case SHOES
    case UNKNOWN
    
    var id: String { "\(self)" }
    
    var title: String {
        switch self {
        case .TOP: "상의"
        case .BOTTOM: "하의"
        case .OUTER: "아우터"
        case .ONEPIECE: "원피스"
        case .ACCESSORY: "악세서리"
        case .BAG: "가방"
        case .SHOES: "신발"
        case .UNKNOWN: ""
        }
    }
    
    init(from decoder: Decoder) throws {
        self = try Category(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
    
    var subCategoryArray: [SubCategory] {
        switch self {
        case .TOP:
            [.SWEATSHIRT, .SHIRT_BLOUSE, .HOODIE, .KNIT, .T_SHIRT, .SLEEVELESS]
        case .BOTTOM:
            [.JEANS, .SLACKS, .SHORTS, .JUMPSUIT, .SKIRT]
        case .OUTER:
            [.JACKET, .ZIP_UP_HOODIE, .CARDIGAN, .FLEECE, .COAT, .PUFFER, .VEST]
        case .ONEPIECE:
            []
        case .ACCESSORY:
            []
        case .BAG:
            []
        case .SHOES:
            []
        case .UNKNOWN:
            []
        }
    }
}
