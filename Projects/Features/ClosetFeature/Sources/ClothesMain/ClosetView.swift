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
    @StateObject private var viewModel: ClosetViewModel
    
    @State private var clothesLink: String = ""
    @State private var filterSelection: ClothesFilter = .init()
    
    @State private var showCategorySheet: Bool = false
    @State private var showMoodSheet: Bool = false
    
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
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack {
                    LinkBanner(urlString: $clothesLink) {
                        if clothesLink.isEmpty { return }
                        clothesLink = clothesLink.split(separator: " ").filter { $0.contains("https://") }.joined()
                        viewModel.urlDidParse.send(clothesLink)
                        clothesLink.removeAll()
                        isFocused = false
                    }
                    .padding(.vertical, 28)
                    .id("LinkField")
                    .focused($isFocused)
                    .onTapGesture {
                        isFocused = false
                    }
                    .onChange(of: viewModel.isFocused) { _, newValue in
                        if !newValue { return }
                        withAnimation(.smooth(duration: 0.2)) {
                            scrollProxy.scrollTo("LinkField", anchor: .top)
                        }
                        
                        isFocused = newValue
                        viewModel.resetFocused()
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
                                ForEach(viewModel.clothesList) { clothes in
                                    Button {
                                        viewModel.presentDetail(id: clothes.id)
                                    } label: {
                                        Rectangle()
                                            .fill(.clear)
                                            .aspectRatio(5/6, contentMode: .fit)
                                            .overlay {
                                                //                                            CachedAsyncImage(clothes.imageUrl)
                                                AsyncImage(url: URL(string: clothes.imageUrl)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                } placeholder: {
                                                    SkeletonView()
                                                }
                                            }
                                    }
                                    .onAppear {
                                        guard let last = viewModel.clothesList.last,
                                              clothes.id == last.id
                                        else { return }
                                        
                                        viewModel.closetDidScroll.send(())
                                    }
                                }
                            }
                        } header: {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(userNickname + " 옷장")
                                    .negguFont(.title3)
                                    .foregroundStyle(.labelNormal)
                                    .lineLimit(1)
                                
                                HStack {
                                    FilterButton(title: filterSelection.categoryTitle) {
                                        showCategorySheet = true
                                    }
                                    .sheet(isPresented: $showCategorySheet) {
                                        CategorySheet(
                                            categorySelection: $filterSelection.category,
                                            subCategorySelection: $filterSelection.subCategory
                                        )
                                        .presentationCornerRadius(20)
                                        .presentationBackground(.bgNormal)
                                        .presentationDetents([.fraction(0.85)])
                                    }
                                    
                                    FilterButton(title: filterSelection.moodTitle) {
                                        showMoodSheet = true
                                    }
                                    .sheet(isPresented: $showMoodSheet) {
                                        MoodSheet(selection: $filterSelection.moodList, isSingleSelection: true)
                                            .presentationCornerRadius(20)
                                            .presentationBackground(.bgNormal)
                                            .presentationDetents([.fraction(0.85)])
                                    }
                                    
                                    if filterSelection.category != .UNKNOWN || !filterSelection.moodList.isEmpty {
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
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }
            .scrollDismissesKeyboard(.immediately)
            .ignoresSafeArea(.keyboard)
            .padding(.top, 1)
            .background(.bgNormal)
        }
        .refreshable {
            filterSelection = .init()
            viewModel.closetDidRefresh.send(())
        }
        .onAppear {
            viewModel.viewDidAppear.send(())
        }
    }
}
