//
//  InsightEntity.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Foundation

struct InsightEntity: Decodable {
    let nickname: String
    let mood: Mood
    let clothes: [ClothesEntity]
    let clothCount: Int
    let lookBooks: [LookBookEntity]
    let lookBookCount: Int
}
