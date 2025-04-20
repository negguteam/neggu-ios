//
//  TokenEntity.swift
//  neggu
//
//  Created by 유지호 on 1/3/24.
//

struct TokenEntity: Decodable {
    let status: String?
    let accessToken: String?
    let accessTokenExpiresIn: Int?
    let refreshToken: String?
    let refreshTokenExpiresIn: Int?
    let registerToken: String?
    
    enum CodingKeys: String, CodingKey {
        case status, accessToken, refreshToken, refreshTokenExpiresIn, registerToken
        case accessTokenExpiresIn = "expiresIn"
    }
}
