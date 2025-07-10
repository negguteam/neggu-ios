//
//  NegguApp.swift
//  Neggu
//
//  Created by 유지호 on 8/3/24.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import NegguDS
import BaseFeature
import AuthFeature
import RootFeature

import SwiftUI
import KakaoSDKCommon
import FirebaseCore

@main
struct NegguApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    init() {
        registerDependency()
        
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLogined {
                RootView(tabRouter: .init())
            } else {
                AuthView(router: .init())
            }
        }
    }
}
