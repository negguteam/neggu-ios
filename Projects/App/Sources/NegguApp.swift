//
//  NegguApp.swift
//  Neggu
//
//  Created by 유지호 on 8/3/24.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct NegguApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() { }
    
    var body: some Scene {
        WindowGroup {
            Color.green
        }
    }
}
