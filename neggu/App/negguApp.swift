//
//  negguApp.swift
//  neggu
//
//  Created by 유지호 on 8/3/24.
//

import SwiftUI
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct negguApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isLogined") private var isLogined: Bool = false
    
    @StateObject private var authCoordinator = AuthCoordinator()
    
    @StateObject private var authViewModel: AuthViewModel = .init()
    
    init() {
        DIContainer.shared.registerPresentationDependencies()
        
        KakaoSDK.initSDK(appKey: NegguEnv.kakaoAppKey)
        
        // MARK: Version Check API
        print(Util.appVersion)
    }
    
    var body: some Scene {
        WindowGroup {
            if isLogined {
                ContentView()
            } else {
                NavigationStack(path: $authCoordinator.path) {
                    authCoordinator.buildScene(.login)
                        .navigationDestination(for: AuthCoordinator.Destination.self) { destination in
                            authCoordinator.buildScene(destination)
                        }
                }
                .environmentObject(authCoordinator)
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    } else {
                        GIDSignIn.sharedInstance.handle(url)
                    }
                }
            }
        }
        .environmentObject(authViewModel)
    }
}
