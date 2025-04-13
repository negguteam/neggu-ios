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
    let imageUrl: String
    let lookBookClothes: [LookBookClothesEntity]
    let decorator: Decorator?
    let createdAt: String
    let modifiedAt: String
    
    struct Decorator: Decodable {
        let id: String
        let imageUrl: String
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
    
    func toLookBookItem(image: UIImage? = nil) -> LookBookClothesItem {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            image: image,
            scale: CGFloat(self.scale),
//            lastScale: CGFloat(self.scale),
            angle: Angle(degrees: Double(self.angle)),
//            lastAngle: Angle(degrees: Double(self.angle)),
            offset: .init(width: CGFloat(self.xRatio), height: CGFloat(self.yRatio)),
            lastOffset: .init(width: CGFloat(self.xRatio), height: CGFloat(self.yRatio)),
            zIndex: Double(self.zIndex)
        )
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

struct LookBookClothesItem: Identifiable, Equatable, Hashable {
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
    
    func toEntity() -> LookBookClothesRegisterEntity {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            scale: Float(self.scale),
            angle: Int(self.angle.degrees),
            xRatio: Float(self.offset.width),
            yRatio: Float(self.offset.height),
            zIndex: Int(zIndex)
        )
    }
}
