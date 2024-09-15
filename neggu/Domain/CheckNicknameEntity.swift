//
//  CheckNicknameEntity.swift
//  neggu
//
//  Created by 유지호 on 8/6/24.
//

struct CheckNicknameEntity: Decodable {
    var isDuplicated: Bool
    
    enum CodingKeys: String, CodingKey {
        case isDuplicated = "is_duplicated"
    }
}
