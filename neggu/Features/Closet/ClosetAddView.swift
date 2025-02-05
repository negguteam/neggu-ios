//
//  ClosetAddView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI

struct ClosetAddView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: ClosetViewModel
    
    // TODO: 이름 수정을 했을 때, 카테고리 변경하면 또 이름이 알아서 편집되는지?
    @State private var clothes: ClothesRegisterEntity
    @State private var clothesColor: UIColor = .clear
    @State private var selectedMoodList: [Mood] = []
    
    @State private var fieldType: FieldType?
    
    @State private var isUnknownCategory: Bool = false
    @State private var isUnknownMood: Bool = false
    
    @State private var showNameEditView: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: FocusField?
    
    private let segmentedImage: UIImage
    
    var name: String {
        if clothes.name.isEmpty {
            [clothes.brand,
//             (clothes.colorCode ?? "").uppercased(),
             clothes.subCategory == .UNKNOWN ? clothes.category.title : clothes.subCategory.title]
                .filter { !$0.isEmpty }.joined(separator: " ")
        } else {
            clothes.name
        }
    }
    
    var categoryTitle: String {
        if clothes.subCategory != .UNKNOWN {
            clothes.category.title + " > " + clothes.subCategory.title
        } else if clothes.category != .UNKNOWN {
            clothes.category.title
        } else {
            "옷의 종류"
        }
    }
    
    var moodTitle: String {
        clothes.mood.map { $0.title }.joined(separator: ", ")
    }
    
    init(clothes: ClothesRegisterEntity, segmentedImage: UIImage) {
        self.clothes = clothes
        self.segmentedImage = segmentedImage
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "multiply")
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
                            Image(uiImage: segmentedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width)
                                .aspectRatio(6/5, contentMode: .fit)
                            
                            LazyVStack(
                                spacing: 20,
                                pinnedViews: [.sectionHeaders]
                            ) {
                                Section {
                                    TitleForm("어떤 종류의 옷인가요?") {
                                        Button {
                                            fieldType = .category
                                        } label: {
                                            HStack {
                                                Text(categoryTitle)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(clothes.category == .UNKNOWN ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.down")
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(isUnknownCategory ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if isUnknownCategory {
                                            Text("옷의 종류를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
                                        
                                        Button {
                                            fieldType = .mood
                                        } label: {
                                            HStack {
                                                Text(clothes.mood.isEmpty ? "옷의 분위기" : moodTitle)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(clothes.mood.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.down")
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(isUnknownMood ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if isUnknownMood {
                                            Text("옷의 분위기를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
                                    }
                                    .id("Category")
                                    .onChange(of: clothes.category) {
                                        isUnknownCategory = false
                                    }
                                    .onChange(of: clothes.mood) {
                                        isUnknownMood = false
                                    }
                                    
                                    TitleForm("어느 브랜드인가요?") {
                                        Button {
                                            fieldType = .brand
                                        } label: {
                                            HStack {
                                                Text(clothes.brand.isEmpty ? "브랜드" : clothes.brand)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(clothes.brand.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.down")
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
                                                        let isSelected = clothes.priceRange == select
                                                        
                                                        BorderedChip(title: select.title, isSelected: isSelected)
                                                            .id(select.id)
                                                            .onTapGesture {
                                                                priceScrollProxy.scrollTo(select.id, anchor: .center)
                                                                clothes.priceRange = select
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
                                                clothes.isPurchase = true
                                            } label: {
                                                BorderedRectangle("구매함", isSelected: clothes.isPurchase)
                                            }
                                            
                                            Button {
                                                clothes.isPurchase = false
                                            } label: {
                                                BorderedRectangle("구매하지 않음", isSelected: !clothes.isPurchase)
                                            }
                                        }
                                        .id(FocusField.link)
                                        
                                        HStack(spacing: 16) {
                                            Image(.link)
                                                .foregroundStyle(.labelAssistive)
                                                .padding(.leading, 12)
                                            
                                            TextField(
                                                "",
                                                text: $clothes.link,
                                                prompt: Text("구매 링크").foregroundStyle(.labelInactive)
                                            )
                                            .negguFont(.body2)
                                            
                                            Button {
                                                
                                            } label: {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(.black)
                                                    .frame(width: 40, height: 40)
                                                    .overlay {
                                                        Image(systemName: "arrow.right")
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
                                        
                                        ExpendableTextView("메모를 남겨보세요! (최대 200자)", text: $clothes.memo)
                                            .focused($focusedField, equals: .memo)
                                    }
                                } header: {
                                    if !name.isEmpty {
                                        HStack {
                                            Button {
                                                showNameEditView = true
                                            } label: {
                                                Text(name)
                                                    .negguFont(.body1b)
                                                    .lineLimit(1)
                                                
                                                Image(systemName: "pencil")
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
                                guard let image = segmentedImage.pngData() else { return }
                                
                                guard clothes.category != .UNKNOWN && !clothes.mood.isEmpty else {
                                    if clothes.category == .UNKNOWN {
                                        isUnknownCategory = true
                                    }
                                    
                                    if clothes.mood.isEmpty {
                                        isUnknownMood = true
                                    }
                                    
                                    scrollProxy.scrollTo("Category", anchor: .top)
                                    
                                    return
                                }
                                
                                clothes.name = name
                                clothes.mood = selectedMoodList
                                
                                viewModel.registerClothes(image: image, clothes: clothes) {
                                    coordinator.dismiss()
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
                        }
                    }
                }
            }
        }
        .background(.bgNormal)
        .ignoresSafeArea(.keyboard)
        .onAppear {
            getMostColor()
        }
        .onTapGesture {
            focusedField = nil
        }
        .sheet(isPresented: $showNameEditView) {
            ClothesNameEditView(clothesName: $clothes.name, placeholder: name)
                .presentationDetents([.height(300)])
                .presentationCornerRadius(20)
        }
        .sheet(item: $fieldType) { fieldType in
            switch fieldType {
            case .category:
                CategorySheet(
                    selectedCategory: $clothes.category,
                    selectedSubCategory: $clothes.subCategory
                )
                .presentationDetents([.fraction(0.85)])
            case .mood:
                MoodSheet(selectedMoodList: $clothes.mood)
                    .presentationDetents([.fraction(0.85)])
            case .brand:
                BrandSheet(selectedBrand: $clothes.brand)
                    .presentationDetents([.fraction(0.85)])
            }
        }
        .negguAlert(
            showAlert: $showAlert,
            title: "의상 등록을 그만둘까요?",
            description: "지금까지 편집한 내용은 저장되지 않습니다.",
            leftContent: "이어서 편집하기",
            rightContent: "그만하기"
        ) {
            coordinator.dismiss()
        }
    }
    
    private func getMostColor() {
        guard let color = segmentedImage.pixelColor(),
              let hexString = color.toHex()
        else { return }
        
        clothesColor = color
        clothes.colorCode = hexString
    }
    
    enum FieldType: Identifiable {
        case category
        case mood
        case brand
        
        var id: String { "\(self)" }
    }
    
    enum FocusField {
        case link
        case memo
    }
}

#Preview {
    ClosetAddView(
        clothes: ClothesRegisterEntity.mockData,
        segmentedImage: .bannerBG1
    )
}
