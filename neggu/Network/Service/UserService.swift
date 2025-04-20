//
//  UserService.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import Foundation
import Combine

typealias DefaultUserService = BaseService<UserAPI>

protocol UserService {
    func profile() -> AnyPublisher<UserProfileEntity, Error>
    func logout() -> AnyPublisher<Void, Error>
    func withdraw() -> AnyPublisher<Void, Error>
}

extension DefaultUserService: UserService {
    
    func profile() -> AnyPublisher<UserProfileEntity, Error> {
        requestObjectWithNetworkError(.profile)
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        requestEmptyBody(.logout)
    }
    
    func withdraw() -> AnyPublisher<Void, Error> {
        requestEmptyBody(.withdraw)
    }
    
}
