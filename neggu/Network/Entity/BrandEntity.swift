//
//  BrandEntity.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation

struct BrandEntity: Decodable, Identifiable {
    let id: String
    let kr: String
    let en: String
//    let genders: [Gender]
//    let moods: [Mood]
}
