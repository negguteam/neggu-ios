//
//  ContentView.swift
//  neggu
//
//  Created by 유지호 on 8/3/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var coordinator = MainCoordinator()
    @StateObject private var closetViewModel = ClosetViewModel()
    @StateObject private var lookBookViewModel = LookBookViewModel()
    @StateObject private var insightViewModel = InsightViewModel()
    
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
            
            if coordinator.isGnbOpened {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        coordinator.isGnbOpened = false
                    }
            }
            
            if coordinator.showGnb {
                BottomNavigationBar()
            }
        }
        .animation(.smooth(duration: 0.2), value: coordinator.isGnbOpened)
        .ignoresSafeArea(.keyboard)
        .sheet(item: $coordinator.sheet) { scene in
            coordinator.buildScene(scene)
        }
        .fullScreenCover(item: $coordinator.fullScreenCover) { scene in
            coordinator.buildScene(scene)
        }
        .environmentObject(coordinator)
        .environmentObject(closetViewModel)
        .environmentObject(lookBookViewModel)
        .environmentObject(insightViewModel)
        .onOpenURL { url in
            let urlComponents = URLComponents(string: url.absoluteString)
            print(urlComponents?.scheme, urlComponents?.host, urlComponents?.path, urlComponents?.queryItems)
        }
    }
}
