//
//  ClosetAddView.swift
//  neggu
//
//  Created by 유지호 on 9/30/24.
//

import SwiftUI
import Combine

struct ClosetAddView: View {
    @Environment(\.dismiss) private var dismiss
    
    // TODO: 이름 수정을 했을 때, 카테고리 변경하면 또 이름이 알아서 편집되는지?
    @State private var clothes: ClothesRegisterEntity
    @State private var clothesColor: UIColor = .clear
    @State private var selectedMoodList: [Mood] = []
    
    @State private var fieldType: FieldType?
    
    @State private var showNameEditView: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState private var focusedField: FocusField?
    
    private let segmentedImage: UIImage
    
    let service = DefaultClosetService()
    
    @State private var bag = Set<AnyCancellable>()
    
    var name: String {
        if clothes.name.isEmpty {
            [clothes.brand,
//             (clothes.colorCode ?? "").uppercased(),
             clothes.subCategory == .UNKNOWN ? clothes.category.rawValue : clothes.subCategory.rawValue]
                .filter { !$0.isEmpty }.joined(separator: " ")
        } else {
            clothes.name
        }
    }
    
    var categoryTitle: String {
        if clothes.subCategory != .UNKNOWN {
            clothes.category.rawValue + " > " + clothes.subCategory.rawValue
        } else if clothes.category != .UNKNOWN {
            clothes.category.rawValue
        } else {
            "옷의 종류"
        }
    }
    
    var moodTitle: String {
        selectedMoodList.map { $0.rawValue }.joined(separator: ", ")
    }
    
    var buttonDisabled: Bool {
        clothes.category == .UNKNOWN || selectedMoodList.isEmpty
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
                                                    .strokeBorder(clothes.category == .UNKNOWN ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if clothes.category == .UNKNOWN {
                                            Text("옷의 종류를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
                                        
                                        Button {
                                            fieldType = .mood
                                        } label: {
                                            HStack {
                                                Text(selectedMoodList.isEmpty ? "옷의 분위기" : moodTitle)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(selectedMoodList.isEmpty ? .labelInactive : .labelNormal)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.down")
                                            }
                                            .padding()
                                            .background() {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(selectedMoodList.isEmpty ? .warning : .lineAlt)
                                            }
                                        }
                                        
                                        if selectedMoodList.isEmpty {
                                            Text("옷의 분위기를 알려주세요!")
                                                .negguFont(.body2)
                                                .foregroundStyle(.warning)
                                        }
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
                                                        
                                                        BorderedChip(title: select.rawValue, isSelected: isSelected)
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
                }
            }
        }
        .background(.bgNormal)
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
                    clothes.name = name
                    clothes.mood = selectedMoodList
                    
                    service.register(
                        image: image,
                        request: clothes
                    ).sink { event in
                        print("ClosetAdd:", event)
                    } receiveValue: { result in
                        debugPrint(result)
                        dismiss()
                    }.store(in: &bag)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(buttonDisabled ? .bgInactive : .negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("저장하기")
                                .negguFont(.body1b)
                                .foregroundStyle(buttonDisabled ? .labelInactive : .labelRNormal)
                        }
                }
                .disabled(buttonDisabled)
                .padding(.horizontal, 48)
            }
        }
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
                MoodSheet(selectedMoodList: $selectedMoodList)
                    .presentationDetents([.fraction(0.85)])
            case .brand:
                BrandSheet(selectedBrand: $clothes.brand)
                    .presentationDetents([.fraction(0.85)])
            }
        }
        .negguAlert(
            showAlert: $showAlert,
            title: "의상 등록을 그만둘까요?",
            description: "지금까지 편집한 내용은 저장되지 않습니다."
        ) {
            dismiss()
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
