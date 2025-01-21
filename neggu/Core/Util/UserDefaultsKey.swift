//
//  UserDefaultsKey.swift
//  neggu
//
//  Created by 유지호 on 8/6/24.
//

import Foundation

public enum UserDefaultsKey {
    enum Auth {
        @UserDefaultsWrapper<String>("accessToken") static var accessToken
        @UserDefaultsWrapper<Date>("accessTokenExpiresIn") static var accessTokenExpiresIn
        @UserDefaultsWrapper<String>("refreshToken") static var refreshToken
        @UserDefaultsWrapper<Date>("refreshTokenExpiresIn") static var refreshTokenExpiresIn
        @UserDefaultsWrapper<String>("registerToken") static var registerToken
        
        @UserDefaultsWrapper<Bool>("isFirstVisit") static var isFirstVisit
        @UserDefaultsWrapper<Bool>("isLogined") static var isLogined
    }
    
    enum User {
        @UserDefaultsWrapper<String>("nickname") static var nickname
        @UserDefaultsWrapper<String>("gender") static var gender
        @UserDefaultsWrapper<[String]>("mood") static var mood
        @UserDefaultsWrapper<Int>("age") static var age
        @UserDefaultsWrapper<String>("fcmToken") static var fcmToken
    }
}

extension UserDefaultsKey {
    
    static func clearUserData() {
        UserDefaultsKey.Auth.accessToken = nil
        UserDefaultsKey.Auth.refreshToken = nil
        UserDefaultsKey.Auth.registerToken = nil
        UserDefaultsKey.Auth.isLogined = nil
    }
    
    static func clearNegguUserData() {
        UserDefaultsKey.User.nickname = nil
        UserDefaultsKey.User.gender = nil
        UserDefaultsKey.User.mood = nil
        UserDefaultsKey.User.age = nil
    }
    
    static func clearPushToken() {
        UserDefaultsKey.User.fcmToken = nil
    }
    
}


@propertyWrapper
private struct UserDefaultsWrapper<T> {
    private let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: key) as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.setValue(newValue, forKey: key)
            }
        }
    }
}
