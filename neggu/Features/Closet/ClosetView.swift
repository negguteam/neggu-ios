//
//  ClosetView.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI

struct ClosetView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @StateObject private var viewModel = ClosetViewModel()
    
    @State private var clothesLink: String = ""
    @State private var filter: ClothesFilter = .init()
    
    @State private var ctaButtonExpanded: Bool = false
    
    @State private var scrollPosition: Int? = 0
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                LinkBanner(urlString: $clothesLink) {
                    if clothesLink.isEmpty { return }
                    clothesLink = clothesLink.split(separator: " ").filter { $0.contains("https://") }.joined()
                    
                    viewModel.send(action: .parseHTML(
                        clothesLink,
                        completion: {
                            Task { @MainActor in
                                guard let result = viewModel.output.parsingResult,
                                      let image = await ImageAnalyzeManager.shared.segmentation(result.imageData)
                                else { return }
                                
                                coordinator.fullScreenCover = .closetAdd(clothes: result.clothes, segmentedImage: image)
                                clothesLink.removeAll()
                                isFocused = false
                            }
                        }
                    ))
                }
                .focused($isFocused)
                .id(0)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("내 옷장")
                        .negguFont(.title2)
                        .foregroundStyle(.labelNormal)
                    
                    HStack {
                        FilterButton(title: filter.categoryTitle) {
                            coordinator.sheet = .categorySheet(category: $filter.category, SubCategory: $filter.subCategory)
                        }
                        
                        FilterButton(title: filter.moodTitle) {
                            coordinator.sheet = .moodSheet(mood: $filter.moodList, isSingleSelection: true)
                        }
                        
                        FilterButton(title: filter.colorTitle) {
                            coordinator.sheet = .colorSheet(color: $filter.color)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(.flexible(), spacing: 18), count: 3),
                            spacing: 16
                        ) {
                            ForEach(viewModel.output.clothes) { item in
                                Button {
                                    coordinator.sheet = .clothesDetail(clothes: item)
                                } label: {
                                    Rectangle()
                                        .fill(.clear)
                                        .aspectRatio(5/6, contentMode: .fit)
                                        .overlay {
                                            CachedAsyncImage(item.imageUrl)
                                        }
                                }
                            }
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 56)
                                .onAppear {
                                    viewModel.send(action: .fetchClothesList)
                                }
                        }
                        .padding(.bottom, viewModel.output.clothes.count % 3 == 0 ? 24 : 80)
                    }
                    .scrollIndicators(.hidden)
                    .scrollDisabled(scrollPosition == 0)
                    .padding(.horizontal, 12)
                }
                .containerRelativeFrame(.vertical)
                .id(1)
            }
            .scrollTargetLayout()
            .padding(.horizontal, 20)
            .padding(.top, 28)
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 1)
        .overlay {
            if ctaButtonExpanded {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        ctaButtonExpanded = false
                    }
            }
        }
        .overlay(alignment: .bottom) {
            NegguCTAButton(isExpanded: $ctaButtonExpanded)
                .opacity(scrollPosition == 0 ? 0 : 1)
                .offset(y: scrollPosition == 0 ? 0 : -78)
                .animation(.smooth, value: scrollPosition)
                .animation(.smooth(duration: 0.3), value: ctaButtonExpanded)
        }
        .background {
            Color.bgNormal
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        }
        .refreshable {
            filter = .init()
            viewModel.send(action: .refresh)
        }
        .onChange(of: filter) { _, newValue in
            viewModel.send(action: .selectFilter(newValue))
        }
    }
    
}
