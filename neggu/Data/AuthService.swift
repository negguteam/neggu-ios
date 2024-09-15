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
    func login(socialType: SocialType, socialID: String, fcmToken: String) -> AnyPublisher<LoginEntity, Error>
    func updateInfo(nickname: String) -> AnyPublisher<LoginEntity, Error>
    func checkNickname(nickname: String) -> AnyPublisher<CheckNicknameEntity, Error>
}

extension DefaultAuthService: AuthService {

    func login(socialType: SocialType, socialID: String, fcmToken: String) -> AnyPublisher<LoginEntity, Error> {
        return requestObjectWithNetworkError(.login(
            socialType: socialType,
            socialID: socialID,
            fcmToken: fcmToken
        ))
    }
    
    func updateInfo(nickname: String) -> AnyPublisher<LoginEntity, Error> {
        return requestObjectWithNetworkError(.updateInfo(nickname: nickname))
    }
    
    func checkNickname(nickname: String) -> AnyPublisher<CheckNicknameEntity, Error> {
        return requestObjectWithNetworkError(.checkNickname(nickname: nickname))
    }
    
}
