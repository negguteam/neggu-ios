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
    
    @StateObject private var mainCoordinator = MainCoordinator()
    @StateObject private var authCoordinator = AuthCoordinator()
    
    @AppStorage("isFirstVisit") private var isFirstVisit: Bool = true
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    init() {
        registerDependency()
        
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if isLogined {
                mainCoordinator.start()
            } else {
                // TODO: Router 작업
                NavigationStack(path: $authCoordinator.path) {
                    authCoordinator.buildScene(isFirstVisit ? .onboarding : .login)
                        .navigationDestination(for: AuthCoordinator.Destination.self) { scene in
                            if #available(iOS 18.0, *) {
                                authCoordinator.buildScene(scene)
                                    .toolbarVisibility(.hidden, for: .navigationBar)
                            } else {
                                authCoordinator.buildScene(scene)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                        }
                }
                .environmentObject(authCoordinator)
            }
        }
        .environmentObject(mainCoordinator)
    }
}
