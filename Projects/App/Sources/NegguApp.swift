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

@main
struct NegguApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var mainCoordinator = MainCoordinator()
    @StateObject private var authCoordinator = AuthCoordinator()
    
    @AppStorage("isFirstVisit") private var isFirstVisit: Bool = true
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    init() {
        registerDependency()
        
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            if isLogined {
                mainCoordinator.start()
            } else {
                NavigationStack(path: $authCoordinator.path) {
                    authCoordinator.buildScene(isFirstVisit ? .onboarding : .login)
                        .navigationDestination(for: AuthCoordinator.Destination.self) { scene in
                            authCoordinator.buildScene(scene)
                        }
                        .environmentObject(authCoordinator)
                }
            }
        }
        .environmentObject(mainCoordinator)
    }
}
