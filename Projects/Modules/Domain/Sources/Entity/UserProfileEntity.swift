//
//  UserProfileEntity.swift
//  neggu
//
//  Created by 유지호 on 3/9/25.
//

import Core

import Foundation

public struct UserProfileEntity: Decodable {
    public let id: String
    public let email: String
    public let nickname: String
    public let gender: Gender
    public let mood: [Mood]
    public let age: Int
    public let profileImage: String?
    public let clothes: [String]
    public let lookBooks: [String]
    public let oauthProvider: String
    public let fcmToken: String?
}
