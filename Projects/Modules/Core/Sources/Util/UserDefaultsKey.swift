//
//  UserDefaultsKey.swift
//  neggu
//
//  Created by 유지호 on 8/6/24.
//

import Foundation

public enum UserDefaultsKey {
    public enum Auth {
        @UserDefaultsWrapper<String>("accessToken") public static var accessToken
        @UserDefaultsWrapper<Date>("accessTokenExpiresIn") public static var accessTokenExpiresIn
        @UserDefaultsWrapper<String>("refreshToken") public static var refreshToken
        @UserDefaultsWrapper<Date>("refreshTokenExpiresIn") public static var refreshTokenExpiresIn
        @UserDefaultsWrapper<String>("registerToken") public static var registerToken
        
        @UserDefaultsWrapper<Bool>("isFirstVisit") public static var isFirstVisit
        @UserDefaultsWrapper<Bool>("isLogined") public static var isLogined
    }
    
    public enum User {
        @UserDefaultsWrapper<String>("nickname") public static var nickname
        @UserDefaultsWrapper<String>("gender") public static var gender
        @UserDefaultsWrapper<[String]>("mood") public static var mood
        @UserDefaultsWrapper<Int>("age") public static var age
        @UserDefaultsWrapper<String>("fcmToken") public static var fcmToken
    }
}

public extension UserDefaultsKey {
    
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
