//
//  LookBookEntity.swift
//  neggu
//
//  Created by 유지호 on 2/16/25.
//

import SwiftUI

struct LookBookEntity: Decodable, Identifiable {
    let id: String
    let accountId: String
    let lookBookId: String
    let imageURL: String
    let lookBookClothes: [LookBookClothesEntity]
    let createdAt: String
    let modifiedAt: String
}

struct LookBookListEntity: Decodable {
    let content: [LookBookEntity]
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct LookBookClothesEntity: Codable, Identifiable, Equatable {
    let id: String
    let imageUrl: String
    var scale: Float
    var angle: Int
    var xratio: Float
    var yratio: Float
    var zindex: Int
}

struct LookBookClothesItem: Identifiable, Equatable {
    let id: String
    let imageUrl: String
    var image: UIImage?
    
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var angle: Angle = .degrees(0)
    var lastAngle: Angle = .degrees(0)
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var zIndex: Double = 0
    
    func toEntity() -> LookBookClothesEntity {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            scale: Float(self.scale),
            angle: Int(self.angle.degrees),
            xratio: Float(self.offset.width),
            yratio: Float(self.offset.height),
            zindex: Int(zIndex)
        )
    }
}


struct Clothes: Equatable, Hashable, Identifiable {
    let id: String = UUID().uuidString
    var sku: String?
    var name: String
    var account: String?
    var link: String
    let imageUrl: String
    var category: Category = .UNKNOWN
    var subCategory: SubCategory = .UNKNOWN
    var mood: Mood = .UNKNOWN
    var brand: String
    var priceRange: PriceRange = .UNKNOWN
    var colorCode: String?
    var memo: String = ""
    var isPurchase: Bool = false
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var angle: Angle = .degrees(0)
    var lastAngle: Angle = .degrees(0)
}
