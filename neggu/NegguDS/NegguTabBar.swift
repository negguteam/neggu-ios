//
//  NegguTabBar.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI
import PhotosUI

enum NegguTab {
    case closet
    case lookbook
}

struct NegguTabBar: View {
    enum TabListType {
        case `default`
        case clothes
    }
    
    @Binding var activeTab: NegguTab
    @Binding var showTabBarList: Bool
    @Binding var selectedCameraPhoto: UIImage?
    
    @Binding var selectedAlbumPhoto: PhotosPickerItem? {
        didSet {
            if selectedAlbumPhoto != nil { showTabBarList = false }
        }
    }
    
    @Binding var createLookBook: Bool
    
    @State private var tapType: TabListType = .default
    
    @State private var showCameraView: Bool = false
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 8) {
            if showTabBarList {
                HStack(alignment: .top, spacing: 6) {
                    if tapType != .default {
                        Button {
                            tapType = .default
                        } label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    switch tapType {
                    case .default:
                        VStack(spacing: 16) {
                            Button {
                                tapType = .clothes
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.shirtFill)
                                    
                                    Text("내 의상 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .frame(height: 32)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                showTabBarList = false
                                createLookBook = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.closetFill)
                                    
                                    Text("룩북 등록하기")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .frame(height: 32)
                            }
                        }
                        .negguFont(.body1b)
                    case .clothes:
                        VStack(alignment: .leading, spacing: 16) {
                            Button {
                                showTabBarList = false
                                activeTab = .closet
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.link)
                                    
                                    Text("링크로 등록하기")
                                    
                                    Spacer()
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Button {
                                showTabBarList = false
                                showCameraView = true
                            } label: {
                                HStack(spacing: 12) {
                                    Image(.camera)
                                    
                                    Text("지금 촬영하고 등록하기")
                                    
                                    Spacer()
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            PhotosPicker(
                                selection: $selectedAlbumPhoto,
                                matching: .all(of: [.images, .screenshots])
                            ) {
                                HStack(spacing: 12) {
                                    Image(.gallery)
                                    
                                    Text("갤러리에서 등록하기")
                                    
                                    Spacer()
                                }
                                .frame(height: 24)
                                .padding(.leading, 18)
                            }
                        }
                        .negguFont(.body2b)
                    }
                }
                .foregroundStyle(.labelRNormal)
                .padding(.horizontal, 36)
                .padding(.vertical, 28)
                .background(.negguSecondary)
                .clipShape(.rect(cornerRadius: 20))
            }
            
            HStack(spacing: 16) {
                Button {
                    if showTabBarList {
                        showTabBarList = false
                    }
                    
                    if activeTab != .closet {
                        activeTab = .closet
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.clear)
                        .overlay {
                            Image(activeTab == .closet ? .shirtFill : .shirt)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                        }
                        .background {
                            if activeTab == .closet {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
                
                Button {
                    showTabBarList.toggle()
                    tapType = .default
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(showTabBarList ? .orange40 : .gray70)
                        .frame(width: 48, height: 48)
                        .overlay {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelRNormal)
                        }
                }
                .zIndex(10)
                
                Button {
                    if showTabBarList {
                        showTabBarList = false
                    }
                    
                    if activeTab != .lookbook {
                        activeTab = .lookbook
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.clear)
                        .overlay {
                            Image(activeTab == .lookbook ? .closetFill : .closet)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                        }
                        .background {
                            if activeTab == .lookbook {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white.opacity(0.2))
                                    .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                        }
                }
            }
            .frame(height: 54)
            .padding(4)
            .background(.black.opacity(0.5))
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 20))
        }
        .frame(width: 328)
        .sheet(isPresented: $showCameraView) {
            ImagePicker(image: $selectedCameraPhoto, isActive: $showCameraView)
                .padding(.top, 20)
                .background(.black)
        }
    }
}
