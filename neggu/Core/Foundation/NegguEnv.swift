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
    
    enum AppsFlyer {
        
        static let devKey: String = {
            guard let key = infoDictionary["APPSFLYER_DEVKEY"] as? String else {
                fatalError("APPSFLYER_DEVKEY not set in plist for this environment")
            }
            
            return key
        }()

        static let appleId: String = {
            guard let id = infoDictionary["APPSFLYER_APPLEID"] as? String else {
                fatalError("APPSFLYER_APPLEID not set in plist for this environment")
            }
            
            return id
        }()
        
        static let oneLinkId: String = {
            guard let id = infoDictionary["APPSFLYER_ONELINKID"] as? String else {
                fatalError("APPSFLYER_ONELINKID not set in plist for this environment")
            }
            
            return id
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
