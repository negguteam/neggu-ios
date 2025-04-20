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
    
    @StateObject private var closetViewModel = DIContainer.shared.resolve(ClosetViewModel.self)
    @StateObject private var lookBookViewModel = DIContainer.shared.resolve(LookBookViewModel.self)
    @StateObject private var insightViewModel = InsightViewModel()
    
    @State private var isTabBarHidden: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available(iOS 18.0, *) {
                TabView(selection: $coordinator.activeTab) {
                    Tab.init(value: .closet) {
                        NavigationStack(path: $coordinator.closetPath) {
                            coordinator.buildScene(.closet)
                                .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                                    coordinator.buildScene(scene)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                    }
                    
                    Tab.init(value: .lookbook) {
                        NavigationStack(path: $coordinator.lookbookPath) {
                            coordinator.buildScene(.lookbook)
                                .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                                    coordinator.buildScene(scene)
                                }
                        }
                        .toolbarVisibility(.hidden, for: .tabBar)
                    }
                }
            } else {
                TabView(selection: $coordinator.activeTab) {
                    NavigationStack(path: $coordinator.closetPath) {
                        coordinator.buildScene(.closet)
                            .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                                coordinator.buildScene(scene)
                            }
                    }
                    .tag(NegguTab.closet)
                    .background {
                        if !isTabBarHidden {
                            HideTabBar {
                                isTabBarHidden = true
                            }
                        }
                    }
                    
                    NavigationStack(path: $coordinator.lookbookPath) {
                        coordinator.buildScene(.lookbook)
                            .navigationDestination(for: MainCoordinator.Destination.self) { scene in
                                coordinator.buildScene(scene)
                            }
                    }
                    .tag(NegguTab.lookbook)
                }
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
                .presentationCornerRadius(20)
                .presentationBackground(.bgNormal)
        }
        .fullScreenCover(item: $coordinator.fullScreenCover) { scene in
            coordinator.buildScene(scene)
        }
        .environmentObject(coordinator)
        .environmentObject(closetViewModel)
        .environmentObject(lookBookViewModel)
        .environmentObject(insightViewModel)
        .onOpenURL { url in
//            let urlComponents = URLComponents(string: url.absoluteString)
//            print(urlComponents?.scheme, urlComponents?.host, urlComponents?.path, urlComponents?.queryItems)
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
