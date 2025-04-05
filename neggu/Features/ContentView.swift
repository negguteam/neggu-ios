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
    
    @State private var selectedCameraPhoto: UIImage?
    @State private var selectedAlbumPhoto: PhotosPickerItem?
    @State private var createLookBook: Bool = false
    
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
            
            if coordinator.showTabbarList {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        coordinator.showTabbarList = false
                    }
            }
            
            if coordinator.showTabbar {
                NegguTabBar(
                    activeTab: $coordinator.activeTab,
                    showTabBarList: $coordinator.showTabbarList,
                    selectedCameraPhoto: $selectedCameraPhoto,
                    selectedAlbumPhoto: $selectedAlbumPhoto,
                    createLookBook: $createLookBook
                )
            }
        }
        .animation(.smooth(duration: 0.2), value: coordinator.showTabbarList)
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
        .onChange(of: selectedCameraPhoto) { _, newValue in
            if newValue == nil { return }
            
            Task.detached(priority: .high) {
                guard let image = newValue,
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(image)
                else { return }
                
                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
                try await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run {
                    coordinator.showTabbarList = false
                    coordinator.fullScreenCover = .closetAdd(clothes: .emptyData, segmentedImage: segmentedImage)
                    selectedCameraPhoto = nil
                }
            }
        }
        .onChange(of: selectedAlbumPhoto) { _, newValue in
            if newValue == nil { return }
            
            Task.detached(priority: .high) {
                let data = try await newValue?.loadTransferable(type: Data.self)
                
                guard let data,
                      let uiImage = UIImage(data: data),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(uiImage)
                else { return }
                
                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
                try await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run {
                    coordinator.showTabbarList = false
                    coordinator.fullScreenCover = .closetAdd(clothes: .emptyData, segmentedImage: segmentedImage)
                    selectedAlbumPhoto = nil
                }
            }
        }
        .onChange(of: createLookBook) { _, newValue in
            if newValue {
                coordinator.fullScreenCover = .lookbookEdit()
                createLookBook = false
            }
        }
    }
}

#Preview {
    ContentView()
}
