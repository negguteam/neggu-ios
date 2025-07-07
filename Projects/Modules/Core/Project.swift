//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Core",
    targets: [.dynamicFramework],
    externalDependencies: [
        .Library.CombineMoya,
        .Library.FirebaseCore,
        .Library.FirebaseMessaging,
        .Library.FirebaseAnalytics,
        .Library.GoogleSignIn,
        .Library.GoogleMobileAds,
        .Library.KakaoSDKCommon,
        .Library.KakaoSDKAuth,
        .Library.KakaoSDKShare,
        .Library.KakaoSDKUser,
        .Library.SwiftSoup,
//        .Library.MarkdownUI
    ]
)
