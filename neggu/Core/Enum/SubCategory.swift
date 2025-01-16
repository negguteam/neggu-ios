//
//  SubCategory.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

enum SubCategory: String, CaseIterable, Identifiable, Decodable {
    // 상의
    case SWEARSHIRT = "맨투맨"
    case SHIRT_BLOUSE = "셔츠/블라우스"
    case HOODIE = "후드"
    case KNIT = "니트"
    case T_SHIRT = "티셔츠"
    case SLEEVELESS = "민소매"
    
    // 하의
    case JEANS = "데님팬츠"
    case SLACKS = "슬랙스"
    case SHORTS = "솟팬츠"
    case JUMPSUIT = "점프슈트"
    case SKIRT = "스커트"
    
    // 아우터
    case JACKET = "자켓"
    case ZIP_UP_HOODIE = "후드집업"
    case CARDIGAN = "가디건"
    case FLEECE = "플리스"
    case COAT = "코트"
    case PUFFER = "패딩"
    case VEST = "베스트"
    
    case UNKNOWN = ""
    
    var id: String { "\(self)" }
    
    init(from decoder: Decoder) throws {
        self = try SubCategory(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
    
    static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
}
