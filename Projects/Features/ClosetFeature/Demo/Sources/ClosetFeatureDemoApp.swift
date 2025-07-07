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
//                closetCoordinator.buildScene(.register(entry: .register(.checkmark, .mockData)))
                closetCoordinator.buildScene(.register(entry: .modify(.init(id: "1234", accountId: "1234", clothId: "1234", name: "멋진 옷", link: "www.neggu.com", imageUrl: "", category: .BOTTOM, subCategory: .JEANS, mood: [.MODERN], brand: "Neggu", priceRange: .FROM_10K_TO_20K, memo: "asss", color: "베이지", colorCode: "", isPurchase: true, modifiedAt: "2"))))
            }
            .sheet(item: $closetCoordinator.sheet) { scene in
                closetCoordinator.buildScene(scene)
                    .presentationCornerRadius(20)
                    .presentationBackground(.bgNormal)
            }
            .fullScreenCover(item: $closetCoordinator.fullScreenCover) { scene in
                closetCoordinator.buildScene(scene)
                    .presentationBackground(.bgNormal)
            }
            .environmentObject(closetCoordinator)
        }
    }
}
