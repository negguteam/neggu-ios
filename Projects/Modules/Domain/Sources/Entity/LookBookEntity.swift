//
//  LookBookEntity.swift
//  neggu
//
//  Created by 유지호 on 2/16/25.
//

import Foundation

public struct LookBookEntity: Codable, Identifiable {
    public let id: String
    public let accountId: String
    public let lookBookId: String
    public let imageUrl: String
    public let lookBookClothes: [LookBookClothesEntity]
    public let decorator: Decorator?
    public let createdAt: String
    public let modifiedAt: String
    
    public init(
        id: String,
        accountId: String,
        lookBookId: String,
        imageUrl: String,
        lookBookClothes: [LookBookClothesEntity],
        decorator: Decorator?,
        createdAt: String,
        modifiedAt: String
    ) {
        self.id = id
        self.accountId = accountId
        self.lookBookId = lookBookId
        self.imageUrl = imageUrl
        self.lookBookClothes = lookBookClothes
        self.decorator = decorator
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }
    
    public struct Decorator: Codable {
        public let accountId: String
        public let imageUrl: String?
        public let targetDate: String
    }
}

public struct LookBookListEntity: Decodable {
    public let content: [LookBookEntity]
    public let first: Bool
    public let last: Bool
    public let empty: Bool
    
    public init(
        content: [LookBookEntity],
        first: Bool,
        last: Bool,
        empty: Bool
    ) {
        self.content = content
        self.first = first
        self.last = last
        self.empty = empty
    }
}


public struct LookBookClothesEntity: Codable, Identifiable, Equatable {
    public let id: String
    public let imageUrl: String
    public var scale: Float
    public var angle: Int
    public var xRatio: Float
    public var yRatio: Float
    public var zIndex: Int
    
    public init(
        id: String,
        imageUrl: String,
        scale: Float,
        angle: Int,
        xRatio: Float,
        yRatio: Float,
        zIndex: Int
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.scale = scale
        self.angle = angle
        self.xRatio = xRatio
        self.yRatio = yRatio
        self.zIndex = zIndex
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageUrl, scale, angle
        case xRatio = "xratio"
        case yRatio = "yratio"
        case zIndex = "zindex"
    }
    
}

public struct LookBookClothesRegisterEntity: Encodable {
    public let id: String
    public let imageUrl: String
    public let scale: Float
    public let angle: Int
    public let xRatio: Float
    public let yRatio: Float
    public let zIndex: Int
    
    public init(
        id: String,
        imageUrl: String,
        scale: Float,
        angle: Int,
        xRatio: Float,
        yRatio: Float,
        zIndex: Int
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.scale = scale
        self.angle = angle
        self.xRatio = xRatio
        self.yRatio = yRatio
        self.zIndex = zIndex
    }
}
