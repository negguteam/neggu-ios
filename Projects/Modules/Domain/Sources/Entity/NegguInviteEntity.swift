//
//  NegguInviteEntity.swift
//  neggu
//
//  Created by 유지호 on 4/7/25.
//

import Foundation

public struct NegguInviteEntity: Decodable {
    public let id: String
    public let accountId: String
    public let expiredAt: Int
    public let createdAt: Int
}
