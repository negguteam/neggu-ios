//
//  ErrorEntity.swift
//  neggu
//
//  Created by 유지호 on 1/3/25.
//

import Foundation

struct ErrorEntity: Decodable, Error {
    let code: String
    let message: String
}
