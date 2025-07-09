//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 9/7/24.
//

import Core
import NegguDS

import BaseFeature

import SwiftUI

struct LookBookRegisterView: View {
    @StateObject private var viewModel: LookBookRegisterViewModel
    
    @State private var selectedClothes: [LookBookClothesItem] = []
    @State private var editingClothes: String = ""
    @State private var showCategoryList: Bool = false
    @State private var isEditingMode: Bool = false
    
    init(viewModel: LookBookRegisterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let frame = $0.frame(in: .local)
            let midX = frame.midX - size.width / 4
            let midY = frame.midY - size.height / 6
            
            ZStack {
                collageView
                    .frame(width: size.width, height: size.height)
                    .onChange(of: editingClothes) { _, newValue in
                        isEditingMode = !newValue.isEmpty
                    }
                
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            viewModel.dismiss()
                        } label: {
                            NegguImage.Icon.largeX
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        Button("저장하기") {
                            if selectedClothes.isEmpty { return }
                            
                            guard let lookBookImage = collageView
                                .frame(width: size.width, height: size.height)
                                .snapshot(),
                                  let pngData = lookBookImage.pngData()
                            else { return }
                            
                            viewModel.registerButtonDidTap.send((pngData, selectedClothes))
                        }
                        .foregroundStyle(selectedClothes.isEmpty ? .labelInactive : .labelNormal)
                        .opacity(isEditingMode ? 0 : 1)
                        .disabled(selectedClothes.isEmpty)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .negguFont(.body2b)
                    .foregroundStyle(.black)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            showCategoryList = true
                        } label: {
                            CategoryCell(viewModel.filter.category, isSelected: true)
                        }
                        .disabled(isEditingMode)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .opacity(isEditingMode ? 0 : 1)
                    .disabled(isEditingMode)
                    .offset(y: isEditingMode ? 118 : 0)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            if viewModel.clothesList.isEmpty {
                                SkeletonView()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 16))
                            }
                            
                            ForEach(viewModel.clothesList) { clothes in
                                let isSelected = selectedClothes.contains(where: { $0.id == clothes.id })
                                let isEditingClothes = editingClothes == clothes.id
                                
                                Button {
                                    if !isSelected {
                                        guard selectedClothes.count < 15 else { return }
                                        
                                        Task {
                                            guard let uiImage = await clothes.imageUrl.toImage() else { return }
                                            
                                            selectedClothes.append(clothes.toLookBookItem(
                                                image: uiImage,
                                                offset: .init(width: midX, height: midY),
                                                zIndex: Double(selectedClothes.count)
                                            ))
                                        }
                                    } else {
                                        selectedClothes.removeAll(where: { $0.id == clothes.id })
                                        
                                        if isEditingClothes {
                                            editingClothes = ""
                                        }
                                    }
                                } label: {
                                    CachedAsyncImage(clothes.imageUrl)
                                        .frame(width: 100, height: 100)
                                        .background(isSelected ? .negguSecondaryAlt : .bgNormal)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(isSelected ? .negguSecondary : .bgNormal)
                                        }
                                        .clipShape(.rect(cornerRadius: 16))
                                }
                                .onAppear {
                                    guard let last = viewModel.clothesList.last,
                                          clothes.id == last.id
                                    else { return }
                                    
                                    viewModel.closetDidScroll.send(())
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, 22)
                    .opacity(isEditingMode ? 0 : 1)
                    .disabled(isEditingMode)
                    .background {
                        UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                            .fill(.white)
                    }
                    .frame(height: 136)
                    .offset(y: isEditingMode ? 118 : 0)
                }
                .animation(.smooth, value: isEditingMode)
                .overlay {
                    if showCategoryList {
                        Color.bgDimmed
                            .ignoresSafeArea()
                            .onTapGesture {
                                showCategoryList = false
                            }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    if showCategoryList {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Category.allCases.filter { $0 != .UNKNOWN }) { category in
                                Button {
                                    viewModel.categoryDidSelect.send(category)
                                    showCategoryList = false
                                } label: {
                                    CategoryCell(category, isSelected: viewModel.filter.category == category)
                                }
                            }
                        }
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 22))
                        .padding(.leading, 20)
                        .padding(.bottom, 156)
                    }
                }
            }
            .frame(width: size.width, height: size.height)
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [.white, .white, NegguDSAsset.Colors.gray10.swiftUIColor]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        }
        .onAppear {
            viewModel.viewDidAppear.send(())
        }
        .negguAlert(
            .needClothes,
            showAlert: $viewModel.isEmptyCloset,
            rightAction: {
                viewModel.dismiss()
            }
        )
    }
    
    private var collageView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ZStack {
                ForEach($selectedClothes) { clothes in
                    ColleageItemView(
                        proxy: proxy,
                        editingClothes: $editingClothes,
                        selectedClothes: $selectedClothes,
                        clothes: clothes
                    )
                    .onTapGesture {
                        editingClothes = editingClothes == clothes.id ? "" : clothes.id
                        
                        guard let index = selectedClothes.firstIndex(where: { $0.id == clothes.id }) else { return }
                        selectedClothes.append(selectedClothes.remove(at: index))
                        
                        for i in selectedClothes.indices {
                            selectedClothes[i].zIndex = Double(i)
                        }
                    }
                }
                
                if isEditingMode {
                    Color.white.opacity(0.3)
                        .zIndex(Double(selectedClothes.count) - 1.5)
                        .onTapGesture {
                            editingClothes = ""
                        }
                }
            }
            .frame(width: size.width, height: size.height)
            .clipped()
        }
    }
}
