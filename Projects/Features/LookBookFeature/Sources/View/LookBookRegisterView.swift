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
    @ObservedObject private var coordinator: BaseCoordinator
    
    @StateObject private var viewModel: LookBookRegisterViewModel
    
    @State private var selectedClothes: [LookBookClothesItem] = []
    
    @State private var editingClothes: String = "" {
        didSet {
            isEditingMode = !editingClothes.isEmpty
        }
    }
    
    @State private var showCategoryList: Bool = false
    @State private var isColorEditMode: Bool = false
    @State private var isEditingMode: Bool = false
    
    init(coordinator: BaseCoordinator, viewModel: LookBookRegisterViewModel) {
        self._coordinator = ObservedObject(wrappedValue: coordinator)
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
                
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            coordinator.dismissFullScreen()
                        } label: {
                            NegguImage.Icon.largeX
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        if isEditingMode {
                            Button("확인하기") {
                                editingClothes = ""
                            }
                        } else {
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
                            .disabled(selectedClothes.isEmpty)
                            .onChange(of: viewModel.registerState) { _, newValue in
                                switch newValue {
                                case .success:
                                    coordinator.dismissFullScreen()
                                case .failure:
                                    AlertManager.shared.setAlert(message: "룩북 등록에 실패했습니다. 다시 시도해주세요.")
                                default:
                                    return
                                }
                            }
                        }
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .negguFont(.body2b)
                    .foregroundStyle(.black)
                    
                    Spacer()
                    
                    if isEditingMode {
                        Button {
                            selectedClothes.removeAll()
                            isColorEditMode = false
                            editingClothes = ""
                        } label: {
                            Circle()
                                .fill(.systemWarning)
                                .frame(width: 72)
                                .overlay {
                                    NegguImage.Icon.delete
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36, height: 36)
                                        .foregroundStyle(.labelRNormal)
                                }
                        }
                        .padding(.bottom, 28)
                    } else {
                        HStack {
                            HStack {
                                if !isColorEditMode {
                                    Button {
                                        showCategoryList = true
                                    } label: {
                                        HStack(spacing: 12) {
                                            NegguImage.Icon.hanger
//                                            Image(viewModel.output.selectedCategory.iconName)
                                                
                                            Text("내 옷장")
                                            
                                            if showCategoryList {
                                                NegguImage.Icon.chevronDown
                                            } else {
                                                NegguImage.Icon.chevronUp
                                            }
                                        }
                                        .negguFont(.body2b)
                                        .foregroundStyle(.negguSecondary)
                                        .frame(height: 44)
                                        .padding(.horizontal, 12)
                                        .background {
                                            RoundedRectangle(cornerRadius: 22)
                                                .fill(.white)
                                        }
                                    }
                                }
                            }
                            .animation(.smooth.delay(isColorEditMode ? 0 : 0.2), value: isColorEditMode)
                            
                            Spacer()
                            
                            HStack {
                                if isColorEditMode {
                                    ScrollView(.horizontal) {
                                        HStack(spacing: 12) {
                                            NegguImage.Icon.colorRainbow
                                                .frame(width: 32)
                                                .onTapGesture {
                                                    viewModel.colorDidSelect.send(nil)
                                                    isColorEditMode = false
                                                }
                                            
                                            ForEach(ColorFilter.allCases) { color in
                                                Circle()
                                                    .stroke(.lineAlt)
                                                    .fill(color.color)
                                                    .frame(width: 32)
                                                    .onTapGesture {
                                                        viewModel.colorDidSelect.send(color)
                                                        isColorEditMode = false
                                                    }
                                            }
                                        }
                                    }
                                    .scrollIndicators(.hidden)
                                    .opacity(isColorEditMode ? 1 : 0)
                                } else {
                                    if let selectedColor = viewModel.filter.color {
                                        Circle()
                                            .fill(selectedColor.color)
                                            .strokeBorder(.lineAlt)
                                            .frame(width: 24)
                                            .opacity(isColorEditMode ? 0 : 1)
                                    } else {
                                        NegguImage.Icon.colorRainbow
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24)
                                            .opacity(isColorEditMode ? 0 : 1)
                                    }
                                }
                                
                                Button {
                                    isColorEditMode.toggle()
                                } label: {
                                    NegguImage.Icon.chevronDown
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.negguSecondary)
                                        .rotationEffect(isColorEditMode ? Angle(degrees: 180.0) : Angle(degrees: 0.0))
                                }
                            }
                            .frame(height: 44)
                            .padding(.horizontal, 8)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 22))
                            .animation(.smooth.delay(isColorEditMode ? 0.2 : 0), value: isColorEditMode)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    
                    UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                        .fill(.white)
                        .frame(height: isEditingMode ? 18 : 136)
                        .overlay(alignment: .top) {
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
                            .padding(.top, 24)
                            .padding(.bottom, 12)
                            .opacity(isEditingMode ? 0 : 1)
                            .disabled(isEditingMode)
                        }
                }
                
                if showCategoryList {
                    ZStack(alignment: .bottomLeading) {
                        Color.bgDimmed
                            .ignoresSafeArea()
                            .onTapGesture {
                                showCategoryList = false
                            }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(Category.allCases.filter { $0 != .UNKNOWN }) { category in
                                Button {
                                    viewModel.categoryDidSelect.send(category)
                                    showCategoryList = false
                                } label: {
                                    HStack(spacing: 0) {
                                        NegguImage.Icon.hanger
//                                        Image(category.iconName)
                                            .frame(width: 24, height: 24)
                                            .padding(.horizontal, 12)
                                        
                                        Text(category.title)
                                        
                                        Spacer()
                                        
                                        if category == .NONE {
                                            NegguImage.Icon.chevronUp
                                                .frame(width: 44, height: 44)
                                        } else {
                                            Color.clear
                                                .frame(width: 44, height: 44)
                                        }
                                    }
                                    .frame(width: 171, height: 44)
                                    .foregroundStyle(
                                        viewModel.filter.category == category
                                        ? .negguSecondary
                                        : .labelInactive
                                    )
                                }
                            }
                        }
                        .negguFont(.body2b)
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
        .task {
            await convertUrlToImage()
        }
        .negguAlert(
            .needClothes,
            showAlert: $viewModel.isEmptyCloset,
            rightAction: {
                coordinator.dismissFullScreen()
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
    
    private func convertUrlToImage() async {
        for i in selectedClothes.indices {
            guard let uiImage = await selectedClothes[i].imageUrl.toImage() else { continue }
            selectedClothes[i].image = uiImage
        }
    }
}
