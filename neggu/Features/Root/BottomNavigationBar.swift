//
//  NegguTabBar.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI
import PhotosUI

struct BottomNavigationBar: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    @State private var gnbState: GnbState = .main
    
    @State private var selectedCameraPhoto: UIImage?
    @State private var selectedAlbumPhoto: PhotosPickerItem?
    
    @State private var showCameraSheet: Bool = false
    @State private var showAlbumSheet: Bool = false
    
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 14) {
            if coordinator.isGnbOpened {
                bottomNavigationOpenedView
            }
            
            HStack(spacing: 16) {
                BottomNavigationBarItem(
                    $coordinator.activeTab,
                    tab: .closet,
                    namespace: namespace
                ) {
                    if coordinator.isGnbOpened { coordinator.isGnbOpened = false }
                    if coordinator.activeTab != .closet { coordinator.activeTab = .closet }
                }
                
                Button {
                    coordinator.isGnbOpened.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(coordinator.isGnbOpened ? .orange40 : .gray70)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(.plus)
                                .foregroundStyle(.labelRNormal)
                        }
                }
                .zIndex(10)
                
                BottomNavigationBarItem(
                    $coordinator.activeTab,
                    tab: .lookbook,
                    namespace: namespace
                ) {
                    if coordinator.isGnbOpened { coordinator.isGnbOpened = false }
                    if coordinator.activeTab != .lookbook { coordinator.activeTab = .lookbook }
                }
            }
            .padding(4)
            .frame(height: 64)
            .background(.black.opacity(0.5))
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
        .frame(width: 328)
        .sheet(isPresented: $showCameraSheet) {
            ImagePicker(image: $selectedCameraPhoto, isActive: $showCameraSheet)
                .padding(.top, 20)
                .background(.black)
        }
        .photosPicker(isPresented: $showAlbumSheet, selection: $selectedAlbumPhoto, matching: .images)
        .onChange(of: coordinator.isGnbOpened) { _, newValue in
            if newValue { return }
            gnbState = .main
        }
        .onChange(of: selectedCameraPhoto) { _, newValue in
            if newValue == nil { return }
            
            Task.detached(priority: .high) {
                guard let image = newValue,
                      let imageData = image.heicData(),//.jpegData(compressionQuality: 1.0),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(imageData)
                else { return }
                
                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
                try await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run {
                    coordinator.fullScreenCover = .clothesRegister(segmentedImage: segmentedImage, clothes: .emptyData)
                    selectedCameraPhoto = nil
                }
            }
        }
        .onChange(of: selectedAlbumPhoto) { _, newValue in
            if newValue == nil { return }
            
            Task.detached(priority: .high) {
                let data = try await newValue?.loadTransferable(type: Data.self)
                
                guard let data,
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(data)
                else { return }
                
                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
                try await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run {
                    coordinator.fullScreenCover = .clothesRegister(segmentedImage: segmentedImage, clothes: .emptyData)
                    selectedAlbumPhoto = nil
                }
            }
        }
    }
    
    @ViewBuilder
    var bottomNavigationOpenedView: some View {
        Group {
            switch gnbState {
            case .main:
                VStack(spacing: 16) {
                    GnbOpendedViewItem("내 의상 등록하기", leftIcon: .shirtFill, rightIcon: .chevronRight) {
                        gnbState = .clothes
                    }
                    .frame(height: 32)
                    
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 1)
                    
                    GnbOpendedViewItem("룩북 등록하기", leftIcon: .closetFill, rightIcon: .chevronRight) {
                        coordinator.isGnbOpened = false
                        coordinator.fullScreenCover(.lookbookRegister())
                    }
                    .frame(height: 32)
                }
                .negguFont(.body1b)
            case .clothes:
                HStack(alignment: .top, spacing: 20) {
                    Button {
                        gnbState = .main
                    } label: {
                        Image(.chevronLeft)
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        GnbOpendedViewItem("링크로 등록하기", leftIcon: .link) {
                            coordinator.isGnbOpened = false
                            coordinator.activeTab = .closet
                        }
                        
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                        
                        GnbOpendedViewItem("지금 촬영하고 등록하기", leftIcon: .camera) {
                            coordinator.isGnbOpened = false
                            showCameraSheet = true
                        }
                        
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                        
                        GnbOpendedViewItem("갤러리에서 등록하기", leftIcon: .gallery) {
                            coordinator.isGnbOpened = false
                            showAlbumSheet = true
                        }
                    }
                    .negguFont(.body2b)
                }
            }
        }
        .foregroundStyle(.labelRNormal)
        .padding(.horizontal, 36)
        .padding(.vertical, 28)
        .background(.negguSecondary)
        .clipShape(.rect(cornerRadius: 20))
    }
    
    enum GnbState {
        case main
        case clothes
    }
}

struct BottomNavigationBarItem: View {
    @Binding var activeTab: NegguTab
    
    let tab: NegguTab
    let namespace: Namespace.ID
    let buttonAction: () -> Void
    
    init(_ activeTab: Binding<NegguTab>, tab: NegguTab, namespace: Namespace.ID, buttonAction: @escaping () -> Void) {
        self._activeTab = activeTab
        self.tab = tab
        self.namespace = namespace
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(.clear)
                .overlay {
                    Image(activeTab == tab ? tab.activeIcon : tab.inactiveIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)
                }
                .background {
                    if activeTab == tab {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white.opacity(0.2))
                            .matchedGeometryEffect(id: "ACTIVETAB", in: namespace)
                    }
                }
        }
    }
}

struct GnbOpendedViewItem: View {
    let title: String
    let leftIcon: ImageResource?
    let rightIcon: ImageResource?
    let buttonAction: (() -> Void)?
    
    init(
        _ title: String,
        leftIcon: ImageResource? = nil,
        rightIcon: ImageResource? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        if let buttonAction {
            Button {
                buttonAction()
            } label: {
                HStack(spacing: 12) {
                    if let leftIcon {
                        Image(leftIcon)
                    }
                    
                    Text(title)
                    
                    Spacer()
                    
                    if let rightIcon {
                        Image(rightIcon)
                    }
                }
            }
        } else {
            HStack(spacing: 12) {
                if let leftIcon {
                    Image(leftIcon)
                }
                
                Text(title)
                
                Spacer()
                
                if let rightIcon {
                    Image(rightIcon)
                }
            }
        }
    }
}


enum NegguTab {
    case closet
    case lookbook
    
    var activeIcon: ImageResource {
        switch self {
        case .closet: .shirtFill
        case .lookbook: .closetFill
        }
    }
    
    var inactiveIcon: ImageResource {
        switch self {
        case .closet: .shirt
        case .lookbook: .closet
        }
    }
}
