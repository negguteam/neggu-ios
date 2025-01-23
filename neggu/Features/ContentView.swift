//
//  ContentView.swift
//  neggu
//
//  Created by 유지호 on 8/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = MainCoordinator()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $coordinator.activeTab) {
                NavigationStack(path: $coordinator.closetPath) {
                    coordinator.buildScene(.closet)
                        .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                            coordinator.buildScene(scene)
                        }
                }
                .tag(NegguTab.closet)
                .toolbar(.hidden, for: .tabBar)
                
                NavigationStack(path: $coordinator.lookbookPath) {
                    coordinator.buildScene(.lookbook)
                        .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                            coordinator.buildScene(scene)
                        }
                }
                .tag(NegguTab.lookbook)
                .toolbar(.hidden, for: .tabBar)
            }
            .sheet(item: $coordinator.sheet) { scene in
                coordinator.buildScene(scene)
            }
            .fullScreenCover(item: $coordinator.fullScreenCover) { scene in
                coordinator.buildScene(scene)
            }
            
            if coordinator.showTabbarList {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        coordinator.showTabbarList = false
                    }
            }
            
            if coordinator.showTabbar {
                NegguTabBar(activeTab: $coordinator.activeTab, showTabBarList: $coordinator.showTabbarList)
            }
        }
        .environmentObject(coordinator)
        .animation(.smooth(duration: 0.2), value: coordinator.showTabbarList)
    }
}

#Preview {
    ContentView()
}
