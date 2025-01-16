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
    func tokenReissuance(completion: @escaping (Bool) -> Void)
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
    
    func tokenReissuance(completion: @escaping (Bool) -> Void) {
        provider.request(.tokenReissuance) { result in
            switch result {
            case .success(let value):
                do {
                    let body = try JSONDecoder().decode(TokenEntity.self, from: value.data)
                    
                    guard let accessToken = body.accessToken,
                          let accessTokenExpiresIn = body.accessTokenExpiresIn,
                          let refreshToken = body.refreshToken,
                          let refreshTokenExpiresIn = body.refreshTokenExpiresIn
                    else {
                        throw ErrorEntity(code: 403, message: "토큰 갱신 실패")
                    }
                    
                    UserDefaultsKey.Auth.accessToken = accessToken
                    UserDefaultsKey.Auth.accessTokenExpiresIn = Date.now.addingTimeInterval(Double(accessTokenExpiresIn))
                    UserDefaultsKey.Auth.refreshToken = refreshToken
                    UserDefaultsKey.Auth.refreshTokenExpiresIn = Date.now.addingTimeInterval(Double(refreshTokenExpiresIn))
                    completion(true)
                } catch {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
    
}
