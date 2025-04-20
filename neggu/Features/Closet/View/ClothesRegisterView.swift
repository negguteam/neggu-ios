//
//  ClothesRegisterView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI

struct ClothesRegisterView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @EnvironmentObject private var lookBookViewModel: LookBookViewModel
    @ObservedObject private var viewModel: ClothesRegisterViewModel
    
    @State private var showNameEditView: Bool = false
    @State private var showCategorySheet: Bool = false
    @State private var showMoodSheet: Bool = false
    @State private var showBrandSheet: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: FocusField?
    
    private let editType: ClothesEditType
    
    init(
        viewModel: ClothesRegisterViewModel,
        editType: ClothesEditType
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.editType = editType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Image(.xLarge)
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
                                switch editType {
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
                                            showCategorySheet = true
                                        } label: {
                                            HStack {
                                                Text(viewModel.categoryString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.output.clothes.category == .UNKNOWN ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(.chevronDown)
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(viewModel.output.isUnknownedCategory ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if viewModel.output.isUnknownedCategory {
                                            Text("옷의 종류를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
                                        
                                        Button {
                                            showMoodSheet = true
                                        } label: {
                                            HStack {
                                                Text(viewModel.moodString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.output.clothes.mood.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(.chevronDown)
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(viewModel.output.isUnknownedMood ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if viewModel.output.isUnknownedMood {
                                            Text("옷의 분위기를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
                                    }
                                    .id("Category")
                                    
                                    TitleForm("어느 브랜드인가요?") {
                                        Button {
                                            showBrandSheet = true
                                        } label: {
                                            HStack {
                                                Text(viewModel.brandString)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(viewModel.output.clothes.brand.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(.chevronDown)
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
                                                        let isSelected = viewModel.output.clothes.priceRange == select
                                                        
                                                        BorderedChip(title: select.title, isSelected: isSelected)
                                                            .id(select.id)
                                                            .onTapGesture {
                                                                priceScrollProxy.scrollTo(select.id, anchor: .center)
                                                                viewModel.send(action: .editPrice(select))
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 28)
                                            }
                                            .scrollIndicators(.hidden)
                                            .padding(.horizontal, -28)
                                        }
                                    }
                                    
                                    TitleForm("어디서 구매하나요?") {
                                        HStack(spacing: 18) {
                                            Button {
                                                viewModel.send(action: .editPurchase(true))
                                            } label: {
                                                BorderedRectangle("구매함", isSelected: viewModel.output.clothes.isPurchase)
                                            }
                                            
                                            Button {
                                                viewModel.send(action: .editPurchase(false))
                                            } label: {
                                                BorderedRectangle("구매하지 않음", isSelected: !viewModel.output.clothes.isPurchase)
                                            }
                                        }
                                        .id(FocusField.link)
                                        
                                        HStack(spacing: 16) {
                                            Image(.link)
                                                .foregroundStyle(.labelAssistive)
                                                .padding(.leading, 12)
                                            
                                            TextField(
                                                "",
                                                text: Binding(
                                                    get: { viewModel.output.clothes.link },
                                                    set: { viewModel.send(action: .editLink($0)) }
                                                ),
                                                prompt: Text("구매 링크").foregroundStyle(.labelInactive)
                                            )
                                            .negguFont(.body2)
                                            
                                            Button {
                                                
                                            } label: {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(.black)
                                                    .frame(width: 40, height: 40)
                                                    .overlay {
                                                        Image(.arrowRight)
                                                            .foregroundStyle(.white)
                                                    }
                                            }
                                        }
                                        .id(FocusField.memo)
                                        .focused($focusedField, equals: .link)
                                        .padding(8)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(.lineAlt)
                                        }
                                        
                                        ExpendableTextView(
                                            "메모를 남겨보세요! (최대 200자)",
                                            text: Binding(
                                                get: { viewModel.output.clothes.memo },
                                                set: { viewModel.send(action: .editMemo($0)) }
                                            )
                                        )
                                        .focused($focusedField, equals: .memo)
                                    }
                                } header: {
                                    if !viewModel.name.isEmpty {
                                        HStack {
                                            Button {
                                                showNameEditView = true
                                            } label: {
                                                Text(viewModel.name)
                                                    .negguFont(.body1b)
                                                    .lineLimit(1)
                                                
                                                Image(.edit)
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
                                guard viewModel.output.clothes.category != .UNKNOWN && !viewModel.output.clothes.mood.isEmpty else {
                                    if viewModel.output.clothes.category == .UNKNOWN {
                                        viewModel.send(action: .validateCategory(false))
                                    }
                                    
                                    if viewModel.output.clothes.mood.isEmpty {
                                        viewModel.send(action: .validateMood(false))
                                    }

                                    scrollProxy.scrollTo("Category", anchor: .top)
                                    return
                                }
                                
                                switch editType {
                                case .register(let image, _):
                                    guard let image = image.pngData() else { return }
                                    
                                    viewModel.send(action: .onTapRegister(
                                        image,
                                        completion: {
                                            closetViewModel.send(action: .refresh)
                                            lookBookViewModel.send(action: .fetchUserProfile)
                                            coordinator.dismissFullScreenCover()
                                        }
                                    ))
                                case .modify(let clothes):
                                    viewModel.send(action: .onTapModify(
                                        clothes: clothes,
                                        completion: {
                                            coordinator.dismissFullScreenCover()
                                        }
                                    ))
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
                            .disabled(!viewModel.output.canRegister)
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
        .sheet(isPresented: $showNameEditView) {
            ClothesNameEditView(
                clothesName: Binding(
                    get: { viewModel.output.clothes.name },
                    set: { viewModel.send(action: .editName($0)) }
                ),
                placeholder: viewModel.name
            )
            .presentationDetents([.height(270)])
        }
        .sheet(isPresented: $showCategorySheet) {
            CategorySheet(
                selectedCategory: Binding(
                    get: { viewModel.output.clothes.category },
                    set: { viewModel.send(action: .editCategory($0)) }
                ),
                selectedSubCategory: Binding(
                    get: { viewModel.output.clothes.subCategory },
                    set: { viewModel.send(action: .editSubCategory($0)) }
                )
            )
            .presentationDetents([.fraction(0.85)])
        }
        .sheet(isPresented: $showMoodSheet) {
            MoodSheet(selectedMoodList: Binding(
                get: { viewModel.output.clothes.mood },
                set: { viewModel.send(action: .editMood($0)) }
            ))
            .presentationDetents([.fraction(0.85)])
        }
        .sheet(isPresented: $showBrandSheet) {
            BrandSheet(
                selectedBrand: Binding(
                    get: { viewModel.output.clothes.brand },
                    set: { viewModel.send(action: .editBrand($0)) }
                ),
                brandList: viewModel.output.brandList
            )
            .presentationDetents([.fraction(0.85)])
        }
        .negguAlert(
            showAlert: $showAlert,
            title: "의상 등록을 그만둘까요?",
            description: "지금까지 편집한 내용은 저장되지 않습니다.",
            leftContent: "이어서 편집하기",
            rightContent: "그만하기"
        ) {
            coordinator.dismissFullScreenCover()
        }
        .onAppear {
            switch editType {
            case .register(let image, _):
                getMostColor(image: image)
                viewModel.send(action: .initial(editType))
            case .modify:
                viewModel.send(action: .initial(editType))
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private func getMostColor(image: UIImage) {
        guard let color = image.pixelColor(),
              let hexString = color.toHex()
        else { return }
        
        viewModel.send(action: .editColor(hexString))
    }
    
    enum FocusField {
        case link
        case memo
    }
}
