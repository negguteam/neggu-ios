//
//  NegguEnv.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import Foundation

enum NegguEnv {
    
    enum Network {
        
        static let baseURL: String = {
            guard let urlString = infoDictionary["BASE_URL"] as? String else {
                fatalError("Base URL not set in plist for this environment")
            }
            
            return urlString
        }()
        
    }
    
    static var kakaoAppKey: String {
        guard let appkey = infoDictionary["KAKAO_APP_KEY"] as? String else {
            fatalError("Kakao App Key not set infoplist for this environment")
        }
        
        return appkey
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        
        return dictionary
    }()
    
}
