//
//  RootView.swift
//  RootFeature
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import NegguDS
import BaseFeature
import ClosetFeature
import LookBookFeature

import SwiftUI

struct RootView: View {
    @ObservedObject private var mainCoordinator: MainCoordinator
    
    @StateObject private var closetCoordinator: ClosetCoordinator
    @StateObject private var lookBookCoordinator: LookBookCoordinator
    
    @State private var isTabBarHidden: Bool = false
    
    init(mainCoordinator: MainCoordinator) {
        self._mainCoordinator = ObservedObject(wrappedValue: mainCoordinator)
        self._closetCoordinator = StateObject(wrappedValue: mainCoordinator.makeClosetCoordinator())
        self._lookBookCoordinator = StateObject(wrappedValue: mainCoordinator.makeLookBookCoordinator())
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18.0, *) {
                TabView(selection: $mainCoordinator.activeTab) {
                    Tab.init(value: NegguTab.closet) {
                        NavigationStack(path: $closetCoordinator.path) {
                            closetCoordinator.buildScene(.main)
                                .toolbar(.hidden, for: .navigationBar)
                                .navigationDestination(for: ClosetCoordinator.Destination.self) { scene in
                                    closetCoordinator.buildScene(scene)
                                        .toolbarVisibility(.hidden, for: .navigationBar)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .sheet(item: $closetCoordinator.sheet) { scene in
                            closetCoordinator.buildScene(scene)
                                .presentationCornerRadius(20)
                                .presentationBackground(.bgNormal)
                        }
                        .fullScreenCover(item: $closetCoordinator.fullScreenCover) { scene in
                            closetCoordinator.buildScene(scene)
                                .presentationBackground(.bgNormal)
                        }
                    }
                    
                    Tab.init(value: NegguTab.lookbook) {
                        NavigationStack(path: $lookBookCoordinator.path) {
                            lookBookCoordinator.buildScene(.main)
                                .navigationDestination(for: LookBookCoordinator.Destination.self) { scene in
                                    lookBookCoordinator.buildScene(scene)
                                        .toolbarVisibility(.hidden, for: .navigationBar)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .environmentObject(lookBookCoordinator)
                    }
                }
            } else {
                TabView(selection: $mainCoordinator.activeTab) {
                    NavigationStack(path: $closetCoordinator.path) {
                        closetCoordinator.buildScene(.main)
                            .navigationDestination(for: ClosetCoordinator.Destination.self) { scene in
                                closetCoordinator.buildScene(scene)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                    .tag(NegguTab.closet)
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
                    .background {
                        if !isTabBarHidden {
                            HideTabBar {
                                isTabBarHidden = true
                            }
                        }
                    }
                    
                    NavigationStack(path: $lookBookCoordinator.path) {
                        lookBookCoordinator.buildScene(.main)
                            .navigationDestination(for: LookBookCoordinator.Destination.self) { scene in
                                lookBookCoordinator.buildScene(scene)
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                    .tag(NegguTab.lookbook)
                }
            }
            
            if mainCoordinator.isGnbOpened {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        mainCoordinator.isGnbOpened = false
                    }
            }
            
            if mainCoordinator.showGnb {
                BottomNavigationBar()
            }
            
            AlertView()
        }
        .animation(.smooth(duration: 0.2), value: mainCoordinator.isGnbOpened)
        .ignoresSafeArea(.keyboard)
//        .sheet(item: $mainCoordinator.sheet) { scene in
//            
//        }
        .fullScreenCover(item: $mainCoordinator.fullScreenCover) { scene in
            mainCoordinator.buildScene(scene)
                .presentationBackground(.bgNormal)
        }
        .environmentObject(closetCoordinator)
        .environmentObject(lookBookCoordinator)
    }
}


fileprivate struct HideTabBar: UIViewRepresentable {
    var result: () -> Void
    
    init(result: @escaping () -> Void) {
        UITabBar.appearance().isHidden = true
        self.result = result
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let tabController = view.tabController {
                UITabBar.appearance().isHidden = false
                tabController.tabBar.isHidden = true
                result()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}

fileprivate extension UIView {
    
    var tabController: UITabBarController? {
        if let controller = sequence(
            first: self,
            next: { $0.next }).first(where: { $0 is UITabBarController }) as? UITabBarController {
            return controller
        }
        
        return nil
    }
    
}
