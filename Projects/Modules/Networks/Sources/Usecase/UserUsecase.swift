//
//  UserUsecase.swift
//  Networks
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import Foundation
import Combine

public protocol UserUsecase {
    var userProfile: PassthroughSubject<UserProfileEntity, Never> { get }
    
    func fetchProfile()
    func logout()
    func withdraw()
}

public final class DefaultUserUsecase: UserUsecase {
    
    public let userProfile = PassthroughSubject<UserProfileEntity, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    private let userService: any UserService
    
    public init(userService: any UserService) {
        self.userService = userService
    }
    
    
    public func fetchProfile() {
        userService.profile()
            .withUnretained(self)
            .sink { event in
                print("FetchProfile:", event)
            } receiveValue: { owner, profile in
                UserDefaultsKey.User.nickname = profile.nickname
                owner.userProfile.send(profile)
            }.store(in: &bag)
    }
    
    public func logout() {
        userService.logout()
            .withUnretained(self)
            .sink { event in
                print("Logout:", event)
            } receiveValue: { owner, _ in
                
            }.store(in: &bag)
    }
    
    public func withdraw() {
        userService.withdraw()
            .withUnretained(self)
            .sink { event in
                print("Withdraw:", event)
            } receiveValue: { owner, _ in
                
            }.store(in: &bag)
    }
    
}

public final class MockUserUsecase: UserUsecase {
    
    public let userProfile = PassthroughSubject<UserProfileEntity, Never>()
    
    private var bag = Set<AnyCancellable>()
    
    public init() { }
    
    
    public func fetchProfile() {
        let mock: UserProfileEntity = .init(
            id: "abcd",
            email: "abcd@neggu.com",
            nickname: "네꾸네꾸",
            gender: .MALE,
            mood: [.MODERN],
            age: 29,
            profileImage: nil,
            clothes: [String](repeating: "n", count: 18),
            lookBooks: [String](repeating: "e", count: 18),
            oauthProvider: "kakao",
            fcmToken: nil
        )
        
        UserDefaultsKey.User.nickname = mock.nickname
        userProfile.send(mock)
    }
    
    public func logout() { }
    
    public func withdraw() { }
    
}
