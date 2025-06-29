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
    
    @StateObject private var authCoordinator = AuthCoordinator()
    
    @AppStorage("isFirstVisit") private var isFirstVisit: Bool = true
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    init() {
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            if isLogined {

            } else {
                NavigationStack(path: $authCoordinator.path) {
                    authCoordinator.buildScene(isFirstVisit ? .onboarding : .login)
                        .navigationDestination(for: AuthCoordinator.Destination.self) { destination in
                            authCoordinator.buildScene(destination)
                        }
                        .environmentObject(authCoordinator)
                }
            }
        }
    }
}
