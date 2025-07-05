//
//  Project+Dependency.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/26/25.
//

import ProjectDescription

public extension TargetDependency {
    
    enum Feature {
        case Auth
        case Closet
        case LookBook
        
        public var project: TargetDependency {
            .project(
                target: "\(self)Feature",
                path: .relativeToRoot("Projects/Features/\(self)Feature")
            )
        }
        
        public var interface: TargetDependency {
            .project(
                target: "\(self)FeatureInterface",
                path: .relativeToRoot("Projects/Features/\(self)Feature")
            )
        }
        
        public static let RootFeature = TargetDependency.project(
            target: "RootFeature",
            path: .relativeToRoot("Projects/Features/RootFeature")
        )
        
        public static let BaseFeature = TargetDependency.project(
            target: "BaseFeature",
            path: .relativeToRoot("Projects/Features/BaseFeature")
        )
    }
    
    
    enum Module {
        case Core
        case Domain
        case Networks
        case NegguDS
        
        public var project: TargetDependency {
            .project(
                target: "\(self)",
                path: .relativeToRoot("Projects/Modules/\(self)")
            )
        }
    }
    
    
    enum Library {
        public static let Moya = TargetDependency.external(name: "Moya")
        public static let CombineMoya = TargetDependency.external(name: "CombineMoya")
        
        public static let GoogleSignIn = TargetDependency.external(name: "GoogleSignIn")
        public static let GoogleMobileAds = TargetDependency.external(name: "GoogleMobileAds")
        public static let FirebaseCore = TargetDependency.external(name: "FirebaseCore")
        public static let FirebaseMessaging = TargetDependency.external(name: "FirebaseMessaging")
        public static let FirebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
        
        public static let KakaoSDKAuth = TargetDependency.external(name: "KakaoSDKAuth")
        public static let KakaoSDKCommon = TargetDependency.external(name: "KakaoSDKCommon")
        public static let KakaoSDKShare = TargetDependency.external(name: "KakaoSDKShare")
        public static let KakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
        
        public static let SwiftSoup = TargetDependency.external(name: "SwiftSoup")
//        public static let MarkdownUI = TargetDependency.external(name: "MarkdownUI")
    }
    
}
