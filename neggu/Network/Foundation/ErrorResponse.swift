//
//  ErrorResponse.swift
//  neggu
//
//  Created by 유지호 on 8/5/24.
//

struct ErrorResponse: Decodable, Equatable {
    let code: Int
    let message: String
}
