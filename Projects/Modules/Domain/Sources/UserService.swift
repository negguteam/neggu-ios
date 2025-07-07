//
//  UserService.swift
//  Domain
//
//  Created by 유지호 on 7/6/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Combine

public protocol UserService {
    func profile() -> AnyPublisher<UserProfileEntity, Error>
    func logout() -> AnyPublisher<Void, Error>
    func withdraw() -> AnyPublisher<Void, Error>
}
