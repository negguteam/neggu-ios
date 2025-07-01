//
//  NegguApp.swift
//  Neggu
//
//  Created by 유지호 on 8/3/24.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import NegguDS

import Networks

import BaseFeature
import ClosetFeature

import SwiftUI

@main
struct ClosetFeatureDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var closetCoordinator = ClosetCoordinator()
    
    init() {
        DIContainer.shared.register(ClosetUsecase.self) {
            DefaultClosetUsecase(closetService: DefaultClosetService())
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $closetCoordinator.path) {
                closetCoordinator.buildScene(.register(entry: .register(.checkmark, .mockData)))
            }
            .environmentObject(closetCoordinator)
        }
    }
}
