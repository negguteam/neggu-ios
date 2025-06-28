//
//  LookBookEntity.swift
//  neggu
//
//  Created by 유지호 on 2/16/25.
//

import Foundation

public struct LookBookEntity: Decodable, Identifiable {
    public let id: String
    public let accountId: String
    public let lookBookId: String
    public let imageUrl: String
    public let lookBookClothes: [LookBookClothesEntity]
    public let decorator: Decorator?
    public let createdAt: String
    public let modifiedAt: String
    
    public struct Decorator: Decodable {
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
}


public struct LookBookClothesEntity: Decodable, Identifiable, Equatable {
    public let id: String
    public let imageUrl: String
    public var scale: Float
    public var angle: Int
    public var xRatio: Float
    public var yRatio: Float
    public var zIndex: Int
    
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
}
