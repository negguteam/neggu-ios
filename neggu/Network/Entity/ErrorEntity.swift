//
//  ErrorEntity.swift
//  neggu
//
//  Created by 유지호 on 1/3/25.
//

import Foundation

struct ErrorEntity: Decodable, Equatable, Error {
    let code: Int
    let message: String
}
