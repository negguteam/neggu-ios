//
//  ContentView.swift
//  neggu
//
//  Created by 유지호 on 8/3/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isTabbarHidden: Bool = false
    @State private var selection: Int = 0
    @State private var showList: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selection) {
                ClosetView()
                    .tag(0)
                    .ignoresSafeArea(edges: .bottom)
                    .background {
                        if !isTabbarHidden {
                            HideTabBar {
                                isTabbarHidden = true
                            }
                        }
                    }
                
                VStack {
                    Button("Logout") {
                        UserDefaultsManager.accountToken = nil
                        UserDefaultsManager.fcmToken = nil
                        UserDefaultsManager.showTabFlow = false
                    }
                }
                .tag(1)
                .ignoresSafeArea(edges: .bottom)
            }
            
            if showList {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showList = false
                        }
                    }
            }
            
            NegguTabBar(selection: $selection, showList: $showList)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
