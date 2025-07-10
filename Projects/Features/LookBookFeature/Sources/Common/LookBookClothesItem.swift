//
//  LookBookClothesItem.swift
//  neggu
//
//  Created by 유지호 on 4/20/25.
//

import Domain

import SwiftUI

struct LookBookClothesItem: Identifiable, Equatable, Hashable {
    let id: String
    let imageUrl: String
    var image: UIImage?
    
    var scale: CGFloat = 1.0
    var startVector: CGVector?
    var startDistance: CGFloat = 1.0
    
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

extension ClothesEntity {
    
    func toLookBookItem(image: UIImage, offset: CGSize = .zero, zIndex: CGFloat = .zero) -> LookBookClothesItem {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            image: image,
            offset: offset,
            lastOffset: offset,
            zIndex: zIndex
        )
    }
    
}

extension LookBookClothesEntity {
    
    func toLookBookItem(image: UIImage? = nil) -> LookBookClothesItem {
        return .init(
            id: self.id,
            imageUrl: self.imageUrl,
            image: image,
            scale: CGFloat(self.scale),
            startDistance: CGFloat(self.scale),
            angle: Angle(degrees: Double(self.angle)),
            lastAngle: Angle(degrees: Double(self.angle)),
            offset: .init(width: CGFloat(self.xRatio), height: CGFloat(self.yRatio)),
            lastOffset: .init(width: CGFloat(self.xRatio), height: CGFloat(self.yRatio)),
            zIndex: Double(self.zIndex)
        )
    }
    
}
