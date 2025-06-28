//
//  BrandEntity.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

public struct BrandEntity: Decodable, Identifiable {
    public let id: String
    public let kr: String
    public let en: String
//    let genders: [Gender]
//    let moods: [Mood]
}
