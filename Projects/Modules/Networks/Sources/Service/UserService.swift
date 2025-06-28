//
//  UserService.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import Foundation
import Combine

public typealias DefaultUserService = BaseService<UserAPI>

public protocol UserService {
    func profile() -> AnyPublisher<UserProfileEntity, Error>
    func logout() -> AnyPublisher<Void, Error>
    func withdraw() -> AnyPublisher<Void, Error>
}

extension DefaultUserService: UserService {
    
    public func profile() -> AnyPublisher<UserProfileEntity, Error> {
        requestObjectWithNetworkError(.profile)
    }
    
    public func logout() -> AnyPublisher<Void, Error> {
        requestEmptyBody(.logout)
    }
    
    public func withdraw() -> AnyPublisher<Void, Error> {
        requestEmptyBody(.withdraw)
    }
    
}
