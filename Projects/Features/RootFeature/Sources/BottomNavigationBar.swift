//
//  NegguTabBar.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import Core
import NegguDS
import BaseFeature

import SwiftUI
import PhotosUI

public struct BottomNavigationBar: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    @State private var gnbState: GnbState = .main
    
    @State private var selectedCameraPhoto: UIImage?
    @State private var selectedAlbumPhoto: PhotosPickerItem?
    
    @State private var showCameraSheet: Bool = false
    @State private var showAlbumSheet: Bool = false
    
    @Namespace private var namespace
    
    public init() { }
    
    public var body: some View {
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
                        .fill(coordinator.isGnbOpened ? .negguSecondary : NegguDSAsset.Colors.gray70.swiftUIColor)
                        .frame(width: 48, height: 48)
                        .overlay {
                            NegguImage.Icon.plus
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
        .padding(.horizontal, 20)
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
            
//            Task.detached(priority: .high) {
//                guard let image = newValue,
//                      let imageData = image.heicData(),
//                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(imageData)
//                else { return }
//                
//                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
//                try await Task.sleep(for: .seconds(0.5))
//                
//                await MainActor.run {
//                    coordinator.fullScreenCover = .clothesRegister(.register(segmentedImage.resize(newWidth: 128), .emptyData))
//                    selectedCameraPhoto = nil
//                }
//            }
        }
        .onChange(of: selectedAlbumPhoto) { _, newValue in
            if newValue == nil { return }
            
//            Task.detached(priority: .high) {
//                let data = try await newValue?.loadTransferable(type: Data.self)
//                
//                guard let data,
//                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(data)
//                else { return }
//                
//                // fullScreenSheet에서 safeArea가 제대로 적용되지 않는 것을 방지
//                try await Task.sleep(for: .seconds(0.5))
//                
//                await MainActor.run {
//                    coordinator.fullScreenCover = .clothesRegister(.register(segmentedImage.resize(newWidth: 128), .emptyData))
//                    selectedAlbumPhoto = nil
//                }
//            }
        }
    }
    
    @ViewBuilder
    private var bottomNavigationOpenedView: some View {
        Group {
            switch gnbState {
            case .main:
                VStack(spacing: 16) {
                    expandedGnbRowItem(
                        "내 의상 등록하기",
                        leftIcon: NegguImage.Icon.shirtFill,
                        rightIcon: NegguImage.Icon.chevronRight
                    ) {
                        gnbState = .clothes
                    }
                    .frame(height: 32)
                    
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 1)
                    
                    expandedGnbRowItem(
                        "룩북 등록하기",
                        leftIcon: NegguImage.Icon.closetFill,
                        rightIcon: NegguImage.Icon.chevronRight
                    ) {
                        coordinator.isGnbOpened = false
//                        coordinator.fullScreenCover(.lookbookRegister())
                    }
                    .frame(height: 32)
                }
                .negguFont(.body1b)
            case .clothes:
                HStack(alignment: .top, spacing: 20) {
                    Button {
                        gnbState = .main
                    } label: {
                        NegguImage.Icon.chevronLeft
                            .frame(width: 24, height: 24)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        expandedGnbRowItem("링크로 등록하기", leftIcon: NegguImage.Icon.link) {
                            coordinator.isGnbOpened = false
                            coordinator.activeTab = .closet
                        }
                        
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                        
                        expandedGnbRowItem("지금 촬영하고 등록하기", leftIcon: NegguImage.Icon.camera) {
                            coordinator.isGnbOpened = false
                            showCameraSheet = true
                        }
                        
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                        
                        expandedGnbRowItem("갤러리에서 등록하기", leftIcon: NegguImage.Icon.gallery) {
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
    
    @ViewBuilder
    private func expandedGnbRowItem(
        _ title: String,
        leftIcon: Image? = nil,
        rightIcon: Image? = nil,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        Button {
            buttonAction?()
        } label: {
            HStack(spacing: 12) {
                if let leftIcon {
                    leftIcon
                }
                
                Text(title)
                
                Spacer()
                
                if let rightIcon {
                    rightIcon
                }
            }
        }
    }
    
    private enum GnbState {
        case main
        case clothes
    }
}

struct BottomNavigationBarItem: View {
    @Binding var activeTab: NegguTab
    
    let tab: NegguTab
    let namespace: Namespace.ID
    let buttonAction: () -> Void
    
    init(
        _ activeTab: Binding<NegguTab>,
        tab: NegguTab,
        namespace: Namespace.ID,
        buttonAction: @escaping () -> Void
    ) {
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
                    Group {
                        if activeTab == tab {
                            tab.activeIcon
                                .resizable()
                        } else {
                            tab.inactiveIcon
                                .resizable()
                        }
                    }
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

fileprivate extension UIImage {
    
    func resize(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
}
