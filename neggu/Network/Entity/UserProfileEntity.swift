//
//  UserProfileEntity.swift
//  neggu
//
//  Created by 유지호 on 3/9/25.
//

import Foundation

struct UserProfileEntity: Decodable {
    let id: String
    let email: String
    let nickname: String
    let gender: Gender
    let mood: [Mood]
    let age: Int
    let profileImage: String?
    let clothes: [String]
    let lookBooks: [String]
    let oauthProvider: String
    let fcmToken: String?
}
