//
//  ClosetView.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import Core
import NegguDS

import BaseFeature

import SwiftUI

public struct ClosetView: View {
    @EnvironmentObject private var coordinator: ClosetCoordinator
    
    @StateObject private var viewModel: ClosetViewModel
    
    @State private var clothesLink: String = ""
    @State private var filterSelection: ClothesFilter = .init()
    @State private var ctaButtonExpanded: Bool = false
    
    @FocusState private var isFocused: Bool
    
    private var userNickname: String {
        if let nickname = UserDefaultsKey.User.nickname {
            nickname + "의"
        } else {
            "내"
        }
    }
    
    public init(viewModel: ClosetViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                LinkBanner(urlString: $clothesLink) {
                    if clothesLink.isEmpty { return }
                    clothesLink = clothesLink.split(separator: " ").filter { $0.contains("https://") }.joined()
                    viewModel.urlDidParse.send(clothesLink)
                }
                .padding(.vertical, 28)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = false
                }
                
                LazyVGrid(
                    columns: [GridItem](repeating: GridItem(.flexible(), spacing: 14), count: 3),
                    spacing: 12,
                    pinnedViews: [.sectionHeaders]
                ) {
                    Section {
                        if viewModel.clothesList.isEmpty {
                            ForEach(0..<6) { _ in
                                Rectangle()
                                    .fill(.clear)
                                    .aspectRatio(5/6, contentMode: .fit)
                            }
                        } else {
                            ForEach(viewModel.clothesList) { item in
                                Button {
                                    coordinator.present(.detail(clothesId: item.id))
                                } label: {
                                    Rectangle()
                                        .fill(.clear)
                                        .aspectRatio(5/6, contentMode: .fit)
                                        .overlay {
                                            CachedAsyncImage(item.imageUrl)
                                        }
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 56)
                            .onAppear {
                                viewModel.closetDidScroll.send(())
                            }
                    } header: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(userNickname + " 옷장")
                                .negguFont(.title2)
                                .foregroundStyle(.labelNormal)
                                .lineLimit(1)
                            
                            HStack {
                                FilterButton(title: filterSelection.categoryTitle) {
                                    coordinator.sheet = .categorySheet(
                                        category: $filterSelection.category,
                                        subCategory: $filterSelection.subCategory
                                    )
                                }
                                
                                FilterButton(title: filterSelection.moodTitle) {
                                    coordinator.sheet = .moodSheet(selection: $filterSelection.moodList, isSingleSelection: true)
                                }
                                
                                FilterButton(title: filterSelection.colorTitle) {
                                    coordinator.sheet = .colorSheet(selection: $filterSelection.color)
                                }
                                
                                if filterSelection.category != .UNKNOWN || !filterSelection.moodList.isEmpty || filterSelection.color != nil {
                                    Button {
                                        filterSelection.reset()
                                    } label: {
                                        NegguImage.Icon.refresh
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(.labelAssistive)
                                    }
                                    .padding(.leading, 4)
                                }
                            }
                            .padding(.vertical)
                            .onChange(of: filterSelection) { oldValue, newValue in
                                guard oldValue != newValue else { return }
                                viewModel.filterDidSelect.send(newValue)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.bgNormal)
                    }
                }
                .background {
                    ListEmptyView(
                        title: "등록된 옷이 없어요!",
                        description: "갖고 있는 옷을 등록해보세요!"
                    )
                    .opacity(viewModel.clothesList.isEmpty ? 1 : 0)
                }
                .onTapGesture {
                    isFocused = false
                }
            }
            .padding(.bottom, 80)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .padding(.horizontal, 20)
        .padding(.top, 1)
        .overlay {
            if ctaButtonExpanded  {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        ctaButtonExpanded = false
                    }
            }
        }
        .overlay(alignment: .bottom) {
            // TODO: Morphing Button으로 리팩토링하기
            NegguCTAButton(isExpanded: $ctaButtonExpanded)
                .offset(y: -78)
                .animation(.smooth(duration: 0.3), value: ctaButtonExpanded)
                .onChange(of: coordinator.rootCoordinator?.isGnbOpened) { _, newValue in
                    if newValue == true {
                        ctaButtonExpanded = false
                    }
                }

        }
        .ignoresSafeArea(.keyboard)
        .background(.bgNormal)
        .refreshable {
            viewModel.closetDidRefresh.send(())
        }
        .onDisappear {
            ctaButtonExpanded = false
        }
        .onChange(of: viewModel.parsingResult) { _, newValue in
            Task.detached(priority: .high) {
                guard let result = newValue,
                      let image = await ImageAnalyzeManager.shared.segmentation(result.imageData)
                else {
                    print("No Result")
                    return
                }
                
                try await Task.sleep(for: .seconds(0.5))
                
                await MainActor.run {
                    clothesLink.removeAll()
                    isFocused = false
                    coordinator.push(.register(entry: .register(image, result.clothes)))
                }
            }
        }
    }
}
