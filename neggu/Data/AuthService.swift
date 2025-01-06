//
//  AuthService.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation
import Combine

typealias DefaultAuthService = BaseService<AuthAPI>

protocol AuthService {
    func login(socialType: SocialType, idToken: String) -> AnyPublisher<TokenEntity, Error>
    func register(userProfile: [String: Any]) -> AnyPublisher<TokenEntity, Error>
    func checkNickname(nickname: String) -> AnyPublisher<CheckNicknameEntity, Error>
}

extension DefaultAuthService: AuthService {

    func login(socialType: SocialType, idToken: String) -> AnyPublisher<TokenEntity, Error> {
        return requestObjectWithNetworkError(.login(
            socialType: socialType,
            idToken: idToken
        ))
    }
    
    func register(userProfile: [String: Any]) -> AnyPublisher<TokenEntity, Error> {
        return requestObjectWithNetworkError(.register(
            parameters: userProfile
        ))
    }
    
    func checkNickname(nickname: String) -> AnyPublisher<CheckNicknameEntity, Error> {
        return requestObjectWithNetworkError(.checkNickname(nickname: nickname))
    }
    
}
