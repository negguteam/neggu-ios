//
//  TokenEntity.swift
//  neggu
//
//  Created by 유지호 on 1/3/24.
//

public struct TokenEntity: Decodable {
    public let status: String?
    public let accessToken: String?
    public let accessTokenExpiresIn: Int?
    public let refreshToken: String?
    public let refreshTokenExpiresIn: Int?
    public let registerToken: String?
    
    enum CodingKeys: String, CodingKey {
        case status, accessToken, refreshToken, refreshTokenExpiresIn, registerToken
        case accessTokenExpiresIn = "expiresIn"
    }
}
