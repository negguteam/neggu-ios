//
//  AuthService.swift
//  Domain
//
//  Created by 유지호 on 7/7/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Combine

public protocol AuthService {
    func login(socialType: SocialType, idToken: String) -> AnyPublisher<TokenEntity, Error>
    func register(userProfile: [String: Any]) -> AnyPublisher<TokenEntity, Error>
    func checkNickname(nickname: String) -> AnyPublisher<CheckNicknameEntity, Error>
    func tokenReissuance(completion: @escaping (Bool) -> Void)
}
