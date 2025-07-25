//
//  InsightEntity.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Core

import Foundation

public struct InsightEntity: Decodable {
    public let nickname: String
    public let mood: Mood
    public let clothes: [ClothesEntity]
    public let clothCount: Int
    public let lookBooks: [LookBookEntity]
    public let lookBookCount: Int
}
