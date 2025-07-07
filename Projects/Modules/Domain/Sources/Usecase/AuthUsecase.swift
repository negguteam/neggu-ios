//
//  AuthUsecase.swift
//  Domain
//
//  Created by 유지호 on 7/7/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import Foundation
import Combine

public protocol AuthUsecase {
    var isSignUpFlow: PassthroughSubject<Bool, Never> { get }
    var isDuplicatedNickname: PassthroughSubject<Bool, Never> { get }
    var isRegistered: PassthroughSubject<Bool, Never> { get }
    
    func checkNickname(_ nickname: String)
    func login(_ socialType: SocialType, idToken: String)
    func register(nickname: String, age: Int, gender: Gender, moodList: [Mood])
}

public final class DefaultAuthUsecase: AuthUsecase {
    
    public let isSignUpFlow = PassthroughSubject<Bool, Never>()
    public let isDuplicatedNickname = PassthroughSubject<Bool, Never>()
    public let isRegistered = PassthroughSubject<Bool, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private let authService: any AuthService
    
    public init(authService: any AuthService) {
        self.authService = authService
    }
    
    public func checkNickname(_ nickname: String) {
        authService.checkNickname(nickname: nickname)
            .withUnretained(self)
            .sink { event in
                print("CheckNickname:", event)
            } receiveValue: { owner, entity in
                owner.isDuplicatedNickname.send(entity.isDuplicate)
            }.store(in: &bag)
    }
    
    public func login(_ socialType: SocialType, idToken: String) {
        authService.login(socialType: socialType, idToken: idToken)
            .withUnretained(self)
            .sink { event in
                print("Login:", event)
            } receiveValue: { owner, entity in
                if let registerToken = entity.registerToken {
                    owner.isSignUpFlow.send(entity.status == "pending")
                    UserDefaultsKey.Auth.registerToken = registerToken
                } else {
                    guard let accessToken = entity.accessToken,
                          let accessTokenExpiresIn = entity.accessTokenExpiresIn,
                          let refreshToken = entity.refreshToken,
                          let refreshTokenExpiresIn = entity.refreshTokenExpiresIn
                    else { return }
                    
                    UserDefaultsKey.Auth.accessToken = accessToken
                    UserDefaultsKey.Auth.accessTokenExpiresIn = Date.now.addingTimeInterval(Double(accessTokenExpiresIn))
                    UserDefaultsKey.Auth.refreshToken = refreshToken
                    UserDefaultsKey.Auth.refreshTokenExpiresIn = Date.now.addingTimeInterval(Double(refreshTokenExpiresIn))
                    UserDefaultsKey.Auth.isLogined = true
                }
            }.store(in: &bag)
    }
    
    public func register(
        nickname: String,
        age: Int,
        gender: Gender,
        moodList: [Mood]
    ) {
        authService.register(userProfile: [
            "nickname": nickname,
            "age": age + 1,
            "gender": gender.id,
            "mood": moodList.map { $0.id },
            "fcmToken": UserDefaultsKey.User.fcmToken ?? ""
        ])
        .withUnretained(self)
        .sink { event in
            print("AuthRegister:", event)
        } receiveValue: { owner, entity in
            guard let accessToken = entity.accessToken,
                  let accessTokenExpiresIn = entity.accessTokenExpiresIn,
                  let refreshToken = entity.refreshToken,
                  let refreshTokenExpiresIn = entity.refreshTokenExpiresIn
            else {
                owner.isRegistered.send(false)
                return
            }
            
            UserDefaultsKey.Auth.accessToken = accessToken
            UserDefaultsKey.Auth.accessTokenExpiresIn = Date.now.addingTimeInterval(Double(accessTokenExpiresIn))
            UserDefaultsKey.Auth.refreshToken = refreshToken
            UserDefaultsKey.Auth.refreshTokenExpiresIn = Date.now.addingTimeInterval(Double(refreshTokenExpiresIn))
            owner.isRegistered.send(true)
        }.store(in: &bag)
    }
    
}


public final class MockAuthUsecase: AuthUsecase {
    
    public let isSignUpFlow = PassthroughSubject<Bool, Never>()
    public let isDuplicatedNickname = PassthroughSubject<Bool, Never>()
    public let isRegistered = PassthroughSubject<Bool, Never>()
    
    public init() { }
    
    public func checkNickname(_ nickname: String) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.isDuplicatedNickname.send(false)
        }
    }
    
    public func login(_ socialType: SocialType, idToken: String) {
        
    }
    
    public func register(
        nickname: String,
        age: Int,
        gender: Gender,
        moodList: [Mood]
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            self.isRegistered.send(true)
        }
    }
    
}
