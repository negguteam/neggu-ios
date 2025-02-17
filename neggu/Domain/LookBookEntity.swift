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
    let imageURL: String
    let lookBookClothes: [LookBookClothesEntity]
    let createdAt: String
    let modifiedAt: String
}

struct LookBookRequestEntity: Decodable {
    let lookBookClothes: [LookBookClothesEntity]
}

struct LookBookClothesEntity: Decodable, Identifiable, Equatable {
    let id: String
    let imageUrl: String
    let scale: Float
    let angle: Int
    let xRatio: Float
    let yRatio: Float
    let zIndex: Int
}
