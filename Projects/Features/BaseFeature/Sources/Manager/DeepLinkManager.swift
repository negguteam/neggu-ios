//
//  DeepLinkManager.swift
//  neggu
//
//  Created by 유지호 on 4/11/25.
//

import SwiftUI
//import AppsFlyerLib
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon

public final class DeepLinkManager: NSObject {
    
    public static let shared = DeepLinkManager()
    
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
    
    
    public func generateUrl(_ target: String, _ queries: [String: String]) -> String {
        var urlString = "negguapp://neggu.com/" + target
        let queryItems = queries.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        
        if !queryItems.isEmpty {
            urlString = urlString + "?" + queryItems
        }
        
//        AppsFlyerShareInviteHelper.generateInviteUrl { generator in
//            generator.addParameterValue("LookBookAdd", forKey: "deep_link_value")
//            generator.addParameterValue(createdInviteCode, forKey: "deep_link_sub1")
//            generator.addParameterValue("negguapp://", forKey: "af_dp")
//            return generator
//        } completionHandler: { url in
//
//        }
        
        return urlString
    }
    
    public func shareToKakao(_ inviteCode: String) {
        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareCustom(
                templateId: 120098,
                templateArgs: ["nickname": "바보", "inviteCode": inviteCode]
            ) { result, error in
                if let error {
                    
                }
                
                if let result {
                    UIApplication.shared.open(result.url)
                }
            }
        }
    }
    
    public func shareToTwitter() {
        let link = "https://neggu-app.onelink.me/prrU/1im1nz1i"
        
        guard let deepLink = URL(string: "twitter://post?message=\(link)") else { return }
        
        if UIApplication.shared.canOpenURL(deepLink) {
            UIApplication.shared.open(deepLink)
        } else {
            guard let webUrl = URL(string: "https://twitter.com/intent/tweet?text=친구의%20룩북을%20꾸며주세요&url=\(link)") else { return }
            
            UIApplication.shared.open(webUrl)
        }
    }
    
    @MainActor
    public func shareToInstagram() {
        let link = "https://neggu-app.onelink.me/prrU/1im1nz1i"
        
        guard let deepLink = URL(string: "instagram-stories://share?source_application=1255607855599668") else { return }
        
//        guard let deepLink = URL(string: "https://www.instagram.com/direct/inbox") else { return }
        
        let image = Text("꾸며주러 가기").snapshot()
        
        if UIApplication.shared.canOpenURL(deepLink) {
            let pasteboardItems: [String: Any?] = [
                "com.instagram.sharedSticker.stickerImage": image?.pngData()
            ]
            
            let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
            
            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            
            UIApplication.shared.open(deepLink)
        } else {
            
        }
    }
    
}


//extension DeepLinkManager: DeepLinkDelegate {
//    
//    func didResolveDeepLink(_ result: DeepLinkResult) {
//        switch result.status {
//        case .found:
//            guard let deepLink = result.deepLink else { return }
//            let deepLinkString = deepLink.toString()
//            
//            print("[AFSDK] Deep link found: \(deepLinkString)")
//            
//            if result.deepLink?.isDeferred == true {
//                print("[AFSDK] This is a deferred deep link")
//            } else {
//                print("[AFSDK] This is a direct deep link")
//            }
//            
////            print(deepLink.deeplinkValue, deepLink.clickEvent["deep_link_sub1"])
//        case .notFound:
//            print("[AFSDK] Deep link not found")
//        case .failure:
//            print("Error %@", result.error!)
//        }
//        
//    }
//    
//}
//
//extension DeepLinkManager: AppsFlyerLibDelegate {
//    
//    func onConversionDataSuccess(_ data: [AnyHashable: Any]) {
//        print("onConversionDataSuccess data:")
//        
//        for (key, value) in data {
//            print(key, ":", value)
//        }
//        
//        if let status = data["af_status"] as? String {
//            if status == "Non-organic" {
//                if let sourceID = data["media_source"], let campaign = data["campaign"] {
//                    print("This is a Non-Organic install. Media source: \(sourceID)  Campaign: \(campaign)")
//                }
//            } else {
//                print("This is an organic install.")
//                
//            }
//            
//            if let is_first_launch = data["is_first_launch"] as? Bool, is_first_launch {
//                print("First Launch")
//            } else {
//                print("Not First Launch")
//            }
//        }
//    }
//    
//    func onConversionDataFail(_ error: Error) {
//        print("\(error)")
//    }
//    
//}
