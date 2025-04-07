//
//  NegguInviteEntity.swift
//  neggu
//
//  Created by 유지호 on 4/7/25.
//

import Foundation

struct NegguInviteEntity: Decodable {
    let id: String
    let accountId: String
    let expiredAt: Int
    let createdAt: Int
}
