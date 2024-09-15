//
//  LoginEntity.swift
//  neggu
//
//  Created by 유지호 on 8/5/24.
//

struct LoginEntity: Codable {
    let publicID: String
    let nickname: String?
    let accountToken: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case publicID = "public_id"
        case nickname
        case accountToken = "account_token"
        case profileImage = "profile_image"
    }
}
