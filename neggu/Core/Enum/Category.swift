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
    case NONE
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
        case .NONE: "전체"
        case .UNKNOWN: ""
        }
    }
    
    var iconName: String {
        switch self {
        case .TOP: "shirt_fill"
        case .BOTTOM: "pants"
        case .OUTER: "outer"
        case .ONEPIECE: "one_piece"
        case .NONE: "hanger"
        case .UNKNOWN: ""
        default: "shose"
        }
    }
    
    init(from decoder: Decoder) throws {
        self = try Category(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .NONE && $0 != .UNKNOWN }
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
            [.DRESS]
        case .ACCESSORY:
            [.NECKLACE, .EARRINGS, .BRACELET, .RING, .HAIR_ACCESSORY, .BELT, .WATCH]
        case .BAG:
            [.BACKPACK, .TOTEBAG, .CLUTHCH, .CROSSBODY_BAG, .SHOULDER_BAG, .LUGGAGE]
        case .SHOES:
            [.SNEAKERS, .DRESS_SHOES, .BOOTS, .SANDALS, .SLIPPERS, .FLATS]
        case .NONE, .UNKNOWN:
            []
        }
    }
}
