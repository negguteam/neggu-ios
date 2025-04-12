//
//  DeepLinkManager.swift
//  neggu
//
//  Created by 유지호 on 4/11/25.
//

import Foundation
import AppsFlyerLib

final class DeepLinkManager: NSObject {
    
    static let shared = DeepLinkManager()
    
    private override init() {
        super.init()
        
//        AppsFlyerLib.shared().appsFlyerDevKey = NegguEnv.AppsFlyer.devKey
//        AppsFlyerLib.shared().appleAppID = NegguEnv.AppsFlyer.appleId
//        AppsFlyerLib.shared().appInviteOneLinkID = NegguEnv.AppsFlyer.oneLinkId
//        
//        AppsFlyerLib.shared().delegate = self
//        AppsFlyerLib.shared().deepLinkDelegate = self
//        
//        AppsFlyerLib.shared().start()
    }
    
    
    func generateUrl(_ target: String, _ queries: [String: String]) -> String {
        var urlString = "negguapp://neggu.com/" + target
        let queryItems = queries.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        
        if !queryItems.isEmpty {
            urlString = urlString + "?" + queryItems
        }
        
        return urlString
    }
    
}


extension DeepLinkManager: DeepLinkDelegate {
    
    func didResolveDeepLink(_ result: DeepLinkResult) {
        switch result.status {
        case .found:
            guard let deepLink = result.deepLink else { return }
            let deepLinkString = deepLink.toString()
            
            print("[AFSDK] Deep link found: \(deepLinkString)")
            
            if result.deepLink?.isDeferred == true {
                print("[AFSDK] This is a deferred deep link")
            } else {
                print("[AFSDK] This is a direct deep link")
            }
            
//            print(deepLink.deeplinkValue, deepLink.clickEvent["deep_link_sub1"])
        case .notFound:
            print("[AFSDK] Deep link not found")
        case .failure:
            print("Error %@", result.error!)
        }
        
    }
    
}

extension DeepLinkManager: AppsFlyerLibDelegate {
    
    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
        print("onConversionDataSuccess data:")
        
        for (key, value) in data {
            print(key, ":", value)
        }
        
        if let status = data["af_status"] as? String {
            if status == "Non-organic" {
                if let sourceID = data["media_source"], let campaign = data["campaign"] {
                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
                }
            } else {
                print("This is an organic install.")
                
            }
            
            if let is_first_launch = data["is_first_launch"] as? Bool, is_first_launch {
                print("First Launch")
            } else {
                print("Not First Launch")
            }
        }
    }
    
    func onConversionDataFail(_ error: Error) {
        print("\(error)")
    }
    
}
