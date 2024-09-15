//
//  UserDefaultsManager.swift
//  neggu
//
//  Created by 유지호 on 8/6/24.
//

import Foundation

public enum UserDefaultsKey {
    case accountToken
    case nickname
    case profileImage
    case fcmToken
    
    case showTabFlow
}

public struct UserDefaultsManager {
    @UserDefaultsWrapper<String>(.accountToken) public static var accountToken
    @UserDefaultsWrapper<String>(.nickname) public static var nickname
    @UserDefaultsWrapper<String>(.profileImage) public static var profileImage
    @UserDefaultsWrapper<String>(.fcmToken) public static var fcmToken
    @UserDefaultsWrapper<Bool>(.showTabFlow) public static var showTabFlow
}

@propertyWrapper
private struct UserDefaultsWrapper<T> {
    private let key: UserDefaultsKey
    
    init(_ key: UserDefaultsKey) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            return UserDefaults.standard.object(forKey: "\(key)") as? T
        }
        
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: "\(key)")
            } else {
                UserDefaults.standard.setValue(newValue, forKey: "\(key)")
            }
        }
    }
}
