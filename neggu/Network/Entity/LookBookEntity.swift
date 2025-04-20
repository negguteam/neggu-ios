//
//  LookBookEntity.swift
//  neggu
//
//  Created by 유지호 on 2/16/25.
//

import Foundation

struct LookBookEntity: Decodable, Identifiable {
    let id: String
    let accountId: String
    let lookBookId: String
    let imageUrl: String
    let lookBookClothes: [LookBookClothesEntity]
    let decorator: Decorator?
    let createdAt: String
    let modifiedAt: String
    
    struct Decorator: Decodable {
        let accountId: String
        let imageUrl: String?
        let targetDate: String
    }
}

struct LookBookListEntity: Decodable {
    let content: [LookBookEntity]
    let first: Bool
    let last: Bool
    let empty: Bool
}


struct LookBookClothesEntity: Decodable, Identifiable, Equatable {
    let id: String
    let imageUrl: String
    var scale: Float
    var angle: Int
    var xRatio: Float
    var yRatio: Float
    var zIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case id, imageUrl, scale, angle
        case xRatio = "xratio"
        case yRatio = "yratio"
        case zIndex = "zindex"
    }
    
}

struct LookBookClothesRegisterEntity: Encodable {
    let id: String
    let imageUrl: String
    let scale: Float
    let angle: Int
    let xRatio: Float
    let yRatio: Float
    let zIndex: Int
}
