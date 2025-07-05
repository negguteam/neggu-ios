//
//  ErrorEntity.swift
//  neggu
//
//  Created by 유지호 on 1/3/25.
//

import Foundation

public struct ErrorEntity: Decodable, Equatable, Error {
    public let code: Int
    public let message: String
    
    public init(
        code: Int,
        message: String
    ) {
        self.code = code
        self.message = message
    }
}
