//
//  Category.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

public enum Category: String, CaseIterable, Identifiable, Codable {
    case TOP
    case BOTTOM
    case OUTER
    case DRESS
    case ACCESSORY
    case BAG
    case SHOES
    case NONE
    case UNKNOWN
    
    public var id: String { "\(self)" }
    
    public var title: String {
        switch self {
        case .TOP: "상의"
        case .BOTTOM: "하의"
        case .OUTER: "아우터"
        case .DRESS: "원피스"
        case .SHOES: "신발"
        case .ACCESSORY: "악세서리"
        case .BAG: "가방"
        case .NONE: "전체"
        case .UNKNOWN: ""
        }
    }
    
    public var iconName: String {
        switch self {
        case .TOP: "shirt_fill"
        case .BOTTOM: "pants"
        case .OUTER: "outer"
        case .DRESS: "one_piece"
        case .SHOES: "shose"
        case .UNKNOWN: ""
        default: "hanger"
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try Category(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
    
    public static var allCasesArray: [Self] {
        allCases.filter { $0 != .NONE && $0 != .UNKNOWN }
    }
    
    public var subCategoryArray: [SubCategory] {
        switch self {
        case .TOP:
            [.SWEATSHIRT, .SHIRT_BLOUSE, .HOODIE, .KNIT, .T_SHIRT, .SLEEVELESS]
        case .BOTTOM:
            [.JEANS, .SLACKS, .SHORTS, .JUMPSUIT, .SKIRT]
        case .OUTER:
            [.JACKET, .ZIP_UP_HOODIE, .CARDIGAN, .FLEECE, .COAT, .PUFFER, .VEST]
        case .DRESS:
            []
        case .SHOES:
            [.SNEAKERS, .DRESS_SHOES, .BOOTS, .SANDALS, .SLIPPERS, .FLATS]
        case .ACCESSORY:
            [.NECKLACE, .EARRINGS, .BRACELET, .RING, .HAIR_ACCESSORY, .BELT, .WATCH]
        case .BAG:
            [.BACKPACK, .TOTEBAG, .CLUTHCH, .CROSSBODY_BAG, .SHOULDER_BAG, .LUGGAGE]
        case .NONE, .UNKNOWN:
            []
        }
    }
}
