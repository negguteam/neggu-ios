//
//  ClothesRegisterView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import Core
import NegguDS

import BaseFeature
import ClosetFeatureInterface

import SwiftUI

public struct ClothesRegisterView: View {
    @ObservedObject private var coordinator: BaseCoordinator
    
    @StateObject private var viewModel: ClothesRegisterViewModel
    
    @State private var categorySelection: Core.Category = .UNKNOWN
    @State private var subCategorySelection: Core.SubCategory = .UNKNOWN
    @State private var moodSelection: [Core.Mood] = []
    @State private var brandSelection: String = ""
    
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: FocusField?
    
    private let entry: ClothesEditType
    
    public init(
        coordinator: BaseCoordinator,
        viewModel: ClothesRegisterViewModel,
        entry: ClothesEditType
    ) {
        self._coordinator = ObservedObject(wrappedValue: coordinator)
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.entry = entry
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    NegguImage.Icon.smallX
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.labelNormal)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            GeometryReader { proxy in
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            Group {
                                switch entry {
                                case .register(let image, _):
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                case .modify(let clothes):
                                    CachedAsyncImage(clothes.imageUrl)
                                }
                            }
                            .frame(width: proxy.size.width, height: proxy.size.width * 1.2)
                            
                            LazyVStack(
                                spacing: 20,
                                pinnedViews: [.sectionHeaders]
                            ) {
                                Section {
                                    TitleForm("어떤 종류의 옷인가요?", isNessesory: true) {
                                        Button {
                                            coordinator.present(.categorySheet(
                                                category: $categorySelection,
                                                subCategory: $subCategorySelection
                                            ))
                                        } label: {
                                            HStack {
                                                Text(viewModel.categoryString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.registerClothes.category == .UNKNOWN ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                NegguImage.Icon.chevronDown
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(!viewModel.isValidCategory ? .systemWarning : .lineAlt)
                                            }
                                        }
                                        
                                        if !viewModel.isValidCategory {
                                            Text("옷의 종류를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.systemWarning)
                                        }
                                        
                                        Button {
                                            coordinator.present(.moodSheet(selection: $moodSelection))
                                        } label: {
                                            HStack {
                                                Text(viewModel.moodString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.registerClothes.mood.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                NegguImage.Icon.chevronDown
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(!viewModel.isValidMood ? .systemWarning : .lineAlt)
                                            }
                                        }
                                        
                                        if !viewModel.isValidMood {
                                            Text("옷의 분위기를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.systemWarning)
                                        }
                                    }
                                    .id("Category")
                                    
                                    TitleForm("어느 브랜드인가요?") {
                                        Button {
                                            coordinator.present(.brandSheet(
                                                selection: $brandSelection,
                                                brandList: viewModel.brandList
                                            ))
                                        } label: {
                                            HStack {
                                                Text(viewModel.brandString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.registerClothes.brand.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                NegguImage.Icon.chevronDown
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(.lineAlt)
                                            }
                                        }
                                    }
                                    
                                    TitleForm("얼마인가요?") {
                                        ScrollViewReader { priceScrollProxy in
                                            ScrollView(.horizontal) {
                                                HStack {
                                                    ForEach(PriceRange.allCases) { select in
                                                        let isSelected = viewModel.registerClothes.priceRange == select

                                                        BorderedChip(title: select.title, isSelected: isSelected)
                                                            .id(select.id)
                                                            .onTapGesture {
                                                                viewModel.priceRangeDidSelect.send(select)
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 28)
                                            }
                                            .scrollIndicators(.hidden)
                                            .padding(.horizontal, -28)
                                            .onAppear {
                                                priceScrollProxy.scrollTo(viewModel.registerClothes.priceRange.id, anchor: .center)
                                            }
                                        }
                                    }
                                    
                                    TitleForm("어디서 구매하나요?") {
                                        HStack(spacing: 18) {
                                            Button {
                                                viewModel.purchaseStateDidSelect.send(true)
                                            } label: {
                                                BorderedRectangle("구매함", isSelected: viewModel.registerClothes.isPurchase)
                                            }
                                            
                                            Button {
                                                viewModel.purchaseStateDidSelect.send(false)
                                            } label: {
                                                BorderedRectangle("구매하지 않음", isSelected: !viewModel.registerClothes.isPurchase)
                                            }
                                        }
                                        .id(FocusField.link)
                                        
                                        HStack(spacing: 16) {
                                            NegguImage.Icon.link
                                                .foregroundStyle(.labelAssistive)
                                                .padding(.leading, 12)
                                            
                                            TextField(
                                                "",
                                                text: Binding(
                                                    get: { viewModel.registerClothes.link },
                                                    set: { viewModel.linkDidEdit.send($0) }
                                                ),
                                                prompt: Text("구매 링크").foregroundStyle(.labelInactive)
                                            )
                                            .negguFont(.body2)
                                        }
                                        .frame(height: 40)
                                        .padding(8)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(.lineAlt)
                                        }
                                        .id(FocusField.memo)
                                        .focused($focusedField, equals: .link)
                                        
                                        ExpendableTextView(
                                            "메모를 남겨보세요! (최대 200자)",
                                            text: Binding(
                                                get: { viewModel.registerClothes.memo },
                                                set: { viewModel.memoDidEdit.send($0) }
                                            )
                                        )
                                        .focused($focusedField, equals: .memo)
                                    }
                                } header: {
                                    if !viewModel.joinedClothesName.isEmpty {
                                        HStack {
                                            Button {
                                                coordinator.sheet = .clothesNameSheet(name: Binding(
                                                    get: { viewModel.registerClothes.name },
                                                    set: { viewModel.nameDidEdit.send($0) }
                                                ))
                                            } label: {
                                                Text(viewModel.joinedClothesName)
                                                    .negguFont(.body1b)
                                                    .lineLimit(1)
                                                
                                                NegguImage.Icon.edit
                                                    .frame(width: 24, height: 24)
                                            }
                                            
                                            Spacer()
                                        }
                                        .frame(height: 48)
                                        .padding(.horizontal, 12)
                                        .background(.bgNormal)
                                    }
                                }
                                .foregroundStyle(.labelNormal)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, focusedField != nil ? proxy.size.height : 140)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollDismissesKeyboard(.immediately)
                    .onChange(of: focusedField) { _, newValue in
                        scrollProxy.scrollTo(newValue, anchor: .top)
                    }
                    .onChange(of: viewModel.isValidCategory) { _, newValue in
                        scrollProxy.scrollTo("Category", anchor: .top)
                    }
                    .onChange(of: viewModel.isValidMood) { _, newValue in
                        scrollProxy.scrollTo("Category", anchor: .top)
                    }
                    .overlay(alignment: .bottom) {
                        ZStack(alignment: .bottom) {
                            LinearGradient(
                                colors: [
                                    Color(red: 248, green: 248, blue: 248, opacity: 0),
                                    Color(red: 248, green: 248, blue: 248, opacity: 1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            .frame(height: 130)
                            .allowsHitTesting(false)
                            
                            Button {
                                switch entry {
                                case .register(let image, _):
                                    guard let imageData = image.pngData() else { return }
                                    viewModel.registerButtonDidTap.send(imageData)
                                case .modify(let clothes):
                                    viewModel.modifyButtonDidTap.send(clothes)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.negguSecondary)
                                    .frame(height: 56)
                                    .overlay {
                                        Text("저장하기")
                                            .negguFont(.body1b)
                                            .foregroundStyle(.labelRNormal)
                                    }
                            }
                            .padding(.horizontal, 48)
                            .onChange(of: viewModel.registState) { _, newValue in
                                switch newValue {
                                case .success:
                                    coordinator.pop()
                                case .failure:
                                    AlertManager.shared.setAlert(message: "의상 편집에 실패했습니다. 다시 시도해주세요.")
                                default:
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(.bgNormal)
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("완료") {
                    focusedField = nil
                }
                .foregroundStyle(.negguSecondary)
            }
        }
        .negguAlert(.cancelRegister(.clothes), showAlert: $showAlert) {
            coordinator.pop()
        }
        .onAppear {
            // 시트 -> 이름, 카테고리, 분위기, 브랜드
            // 옷 등록 -> 색, 이름, 브랜드
            // 옷 수정 -> 이름, 카테고리, 분위기, 브랜드
            switch entry {
            case .register(let image, let clothes):
                if let color = image.pixelColor() {
                    viewModel.colorDidConfigure.send(.init(color: color))
                }

                viewModel.nameDidEdit.send(clothes.name)
                viewModel.brandDidSelect.send(clothes.brand)
                viewModel.linkDidEdit.send(clothes.link)
            case .modify(let clothes):
                viewModel.nameDidEdit.send(clothes.name)
                viewModel.priceRangeDidSelect.send(clothes.priceRange)
                viewModel.purchaseStateDidSelect.send(clothes.isPurchase)
                viewModel.linkDidEdit.send(clothes.link)
                viewModel.memoDidEdit.send(clothes.memo)
                
                categorySelection = clothes.category
                subCategorySelection = clothes.subCategory
                moodSelection = clothes.mood
                brandSelection = clothes.brand
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .onChange(of: categorySelection) { _, newValue in
            viewModel.categoryDidSelect.send(newValue)
        }
        .onChange(of: subCategorySelection) { _, newValue in
            viewModel.subCategoryDidSelect.send(newValue)
        }
        .onChange(of: moodSelection) { _, newValue in
            viewModel.moodDidSelect.send(newValue)
        }
        .onChange(of: brandSelection) { _, newValue in
            viewModel.brandDidSelect.send(newValue)
        }
    }
    
    enum FocusField {
        case link
        case memo
    }
}
