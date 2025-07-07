//
//  SubCategory.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

public enum SubCategory: String, CaseIterable, Identifiable, Codable {
    // 상의
    case SWEATSHIRT
    case SHIRT_BLOUSE
    case HOODIE
    case KNIT
    case T_SHIRT
    case SLEEVELESS
    
    // 하의
    case JEANS
    case SLACKS
    case SHORTS
    case JUMPSUIT
    case SKIRT
    
    // 아우터
    case JACKET
    case ZIP_UP_HOODIE
    case CARDIGAN
    case FLEECE
    case COAT
    case PUFFER
    case VEST
    
    // 원피스
    case DRESS
    
    // 악세서리
    case NECKLACE
    case EARRINGS
    case BRACELET
    case RING
    case HAIR_ACCESSORY
    case BELT
    case WATCH
    
    // 가방
    case BACKPACK
    case TOTEBAG
    case CLUTHCH
    case CROSSBODY_BAG
    case SHOULDER_BAG
    case LUGGAGE
    
    // 신발
    case SNEAKERS
    case DRESS_SHOES
    case BOOTS
    case SANDALS
    case SLIPPERS
    case FLATS
    
    case UNKNOWN
    
    public var id: String { "\(self)" }
    
    public var title: String {
        switch self {
        // 상의
        case .SWEATSHIRT: "맨투맨"
        case .SHIRT_BLOUSE: "셔츠/블라우스"
        case .HOODIE: "후드"
        case .KNIT: "니트"
        case .T_SHIRT: "티셔츠"
        case .SLEEVELESS: "민소매"
        
        // 하의
        case .JEANS: "데님팬츠"
        case .SLACKS: "슬랙스"
        case .SHORTS: "숏팬츠"
        case .JUMPSUIT: "점프슈트"
        case .SKIRT: "스커트"
        
        // 아우터
        case .JACKET: "자켓"
        case .ZIP_UP_HOODIE: "후드집업"
        case .CARDIGAN: "가디건"
        case .FLEECE: "플리스"
        case .COAT: "코트"
        case .PUFFER: "패딩"
        case .VEST: "베스트"
            
        // 원피스
        case .DRESS: "원피스"
        
        // 악세서리
        case .NECKLACE: "목걸이"
        case .EARRINGS: "귀걸이"
        case .BRACELET: "팔찌"
        case .RING: "반지"
        case .HAIR_ACCESSORY: "헤어악세서리"
        case .BELT: "벨트"
        case .WATCH: "시계"
        
        // 가방
        case .BACKPACK: "백팩"
        case .TOTEBAG: "토트백"
        case .CLUTHCH: "클러치"
        case .CROSSBODY_BAG: "크로스백"
        case .SHOULDER_BAG: "숄더백"
        case .LUGGAGE: "여행가방"
        
        // 신발
        case .SNEAKERS: "운동화"
        case .DRESS_SHOES: "구두"
        case .BOOTS: "부츠"
        case .SANDALS: "샌들"
        case .SLIPPERS: "슬리퍼"
        case .FLATS: "플랫슈즈"
        
        case .UNKNOWN: ""
        }
    }
    
    public init(from decoder: Decoder) throws {
        self = try SubCategory(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .UNKNOWN
    }
    
    public static var allCasesArray: [Self] {
        allCases.filter { $0 != .UNKNOWN }
    }
}
