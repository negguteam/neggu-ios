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

public struct RootView: View {
    @StateObject private var tabRouter: TabRouter
    @StateObject private var closetRouter: ClosetRouter
    @StateObject private var lookBookRouter: LookBookMainRouter
    
    @State private var isTabBarHidden: Bool = false
    
    public init(tabRouter: TabRouter) {
        self._tabRouter = StateObject(wrappedValue: tabRouter)
        self._closetRouter = StateObject(wrappedValue: tabRouter.startClosetFlow())
        self._lookBookRouter = StateObject(wrappedValue: tabRouter.startLookBookFlow())
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18.0, *) {
                TabView(selection: $tabRouter.activeTab) {
                    Tab.init(value: NegguTab.closet) {
                        NavigationStack(path: $closetRouter.routers) {
                            closetRouter.start()
                                .toolbar(.hidden, for: .navigationBar)
                                .navigationDestination(for: AnyRoutable.self) { router in
                                    router.makeView()
                                        .toolbarVisibility(.hidden, for: .navigationBar)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .sheet(item: $closetRouter.sheet) { router in
                            router.makeView()
                                .presentationCornerRadius(20)
                                .presentationBackground(.bgNormal)
                        }
                        .fullScreenCover(item: $closetRouter.fullScreen) { router in
                            router.makeView()
                        }
                    }
                    
                    Tab.init(value: NegguTab.lookbook) {
                        NavigationStack(path: $lookBookRouter.routers) {
                            lookBookRouter.start()
                                .navigationDestination(for: AnyRoutable.self) { router in
                                    router.makeView()
                                        .toolbarVisibility(.hidden, for: .navigationBar)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .sheet(item: $lookBookRouter.sheet) { router in
                            router.makeView()
                                .presentationCornerRadius(20)
                                .presentationBackground(.bgNormal)
                        }
                        .fullScreenCover(item: $lookBookRouter.fullScreen) { router in
                            router.makeView()
                        }
                    }
                }
            } else {
                TabView(selection: $tabRouter.activeTab) {
                    NavigationStack(path: $closetRouter.routers) {
                        closetRouter.start()
                            .navigationDestination(for: AnyRoutable.self) { router in
                                router.makeView()
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                    .tag(NegguTab.closet)
                    .sheet(item: $closetRouter.sheet) { router in
                        router.makeView()
                            .presentationCornerRadius(20)
                            .presentationBackground(.bgNormal)
                    }
                    .fullScreenCover(item: $closetRouter.fullScreen) { router in
                        router.makeView()
                    }
                    .background {
                        if !isTabBarHidden {
                            HideTabBar {
                                isTabBarHidden = true
                            }
                        }
                    }
                    
                    NavigationStack(path: $lookBookRouter.routers) {
                        lookBookRouter.start()
                            .navigationDestination(for: AnyRoutable.self) { router in
                                router.makeView()
                                    .toolbar(.hidden, for: .navigationBar)
                            }
                    }
                    .tag(NegguTab.lookbook)
                    .sheet(item: $lookBookRouter.sheet) { router in
                        router.makeView()
                            .presentationCornerRadius(20)
                            .presentationBackground(.bgNormal)
                    }
                    .fullScreenCover(item: $lookBookRouter.fullScreen) { router in
                        router.makeView()
                    }
                }
            }
            
            if tabRouter.isGnbOpened {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        tabRouter.isGnbOpened = false
                    }
            }

            if tabRouter.showGnb {
                BottomNavigationBar()
                    .environmentObject(tabRouter)
                    .environmentObject(closetRouter)
                    .environmentObject(lookBookRouter)
            }
            
            AlertView()
        }
        .animation(.smooth(duration: 0.2), value: tabRouter.isGnbOpened)
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: .init("DeepLink"))) { notification in
            if let url = notification.userInfo?["url"] as? String {
                let components = url.components(separatedBy: "/")
                
                if url.contains("lookBook/detail") {
                    guard let lookBookID = components.last else { return }
                    
                    Task { @MainActor in
                        tabRouter.activeTab = .lookbook
                        try? await Task.sleep(for: .seconds(0.5))
                        lookBookRouter.routeToDetail(id: lookBookID)
                    }
                }
            }
        }
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
