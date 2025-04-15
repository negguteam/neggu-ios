//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 9/7/24.
//

import SwiftUI

struct LookBookEditView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @State private var selectedClothes: [LookBookClothesItem]
    
    @State private var editingClothes: String = "" {
        didSet {
            isEditingMode = !editingClothes.isEmpty
        }
    }
    
    @State private var showNegguState: Bool
    @State private var showNegguInviteAlert: Bool = false
    @State private var showCategoryList: Bool = false
    @State private var isColorEditMode: Bool = false
    @State private var isEditingMode: Bool = false
    
    private let inviteCode: String
    
    init(inviteCode: String, editingClothes: [LookBookClothesItem] = []) {
        self.inviteCode = inviteCode
        self.selectedClothes = editingClothes
        self.showNegguState = !inviteCode.isEmpty
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let frame = $0.frame(in: .local)
            let midX = frame.midX - size.width / 4
            let midY = frame.midY - size.height / 6
            
            collageView
                .frame(width: size.width, height: size.height)
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .white, .gray10]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .overlay {
                    VStack(spacing: 0) {
                        HStack {
                            Button {
                                coordinator.dismiss()
                            } label: {
                                Image(.xLarge)
                                    .frame(width: 44, height: 44)
                            }
                            
                            Spacer()
                            
                            Button("저장하기") {
                                if selectedClothes.isEmpty { return }
                                
                                guard let lookBookImage = collageView
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .snapshot(),
                                      let pngData = lookBookImage.pngData()
                                else { return }
                                
                                let request = selectedClothes.compactMap { $0.toEntity() }
                                
                                if inviteCode.isEmpty {
                                    viewModel.registerLookBook(image: pngData, request: request) {
                                        coordinator.dismiss()
                                    }
                                } else {
                                    viewModel.registerLookBook(image: pngData, request: request, byInvite: true) {
                                        coordinator.dismiss()
                                    }
                                }
                            }
                            .negguFont(.body2b)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.black)
                        .opacity(isEditingMode ? 0 : 1)
                        .disabled(isEditingMode)
                        
                        if inviteCode.isEmpty && !isEditingMode {
                            HStack {
                                Spacer()
                                
                                Button {
                                    showNegguInviteAlert = true
                                } label: {
                                    Circle()
                                        .fill(.black)
                                        .overlay {
                                            Image(.negguStar)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                        .shadow(color: .black.opacity(0.05), radius: 4, x: 4, y: 4)
                                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                                        .frame(width: 44, height: 44)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        }
                        
                        if showNegguState {
                            HStack {
                                Image(.negguStar)
                                
                                Text("ㅇㅇ님의 룩북을 대신 꾸며주고 있어요")
                                    .negguFont(.body2b)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Button {
                                    showNegguState = false
                                } label: {
                                    Image(.xLarge)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            }
                            .padding(.horizontal)
                            .frame(height: 56)
                            .foregroundStyle(.white)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 12)
                        }
                        
                        Spacer()
                        
                        if isEditingMode {
                            Button {
                                selectedClothes.removeAll()
                                isColorEditMode = false
                                editingClothes = ""
                            } label: {
                                Circle()
                                    .fill(.warning)
                                    .frame(width: 72)
                                    .overlay {
                                        Image(systemName: "trash")
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
                                            HStack(spacing: 0) {
                                                Image(viewModel.selectedCategory.iconName)
                                                
                                                HStack(spacing: 0) {
                                                    Text("길동")
                                                        .lineLimit(1)
                                                    
                                                    Text("의 옷장")
                                                        .fixedSize()
                                                }
                                                .padding(.horizontal, 12)
                                                
                                                Image(showCategoryList ? "chevron_down" : "chevron_up")
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
                                                Image("color_rainbow")
                                                    .frame(width: 32)
                                                    .onTapGesture {
                                                        viewModel.selectedColor = nil
                                                        isColorEditMode = false
                                                    }
                                                
                                                ForEach(ColorFilter.allCases) { filter in
                                                    Circle()
                                                        .stroke(.lineAlt)
                                                        .fill(filter.color)
                                                        .frame(width: 32)
                                                        .onTapGesture {
                                                            viewModel.selectedColor = filter
                                                            isColorEditMode = false
                                                        }
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                        .opacity(isColorEditMode ? 1 : 0)
                                    } else {
                                        if let selectedColor = viewModel.selectedColor {
                                            Circle()
                                                .fill(selectedColor.color)
                                                .strokeBorder(.lineAlt)
                                                .frame(width: 24)
                                                .opacity(isColorEditMode ? 0 : 1)
                                        } else {
                                            Image("color_rainbow")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24)
                                                .opacity(isColorEditMode ? 0 : 1)
                                        }
                                    }
                                    
                                    Button {
                                        isColorEditMode.toggle()
                                    } label: {
                                        Image("chevron_down")
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
                                        ForEach(viewModel.lookBookClothes) { clothes in
                                            let isSelected = selectedClothes.contains(where: { $0.id == clothes.id })
                                            let isEditingClothes = editingClothes == clothes.id
                                            
                                            Button {
                                                if !isSelected {
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
                                        }
                                        
                                        Rectangle()
                                            .fill(.clear)
                                            .frame(height: 100)
                                            .onAppear {
                                                if viewModel.clothesPage <= 0 { return }
                                                viewModel.getLookBookClothes(inviteCode: inviteCode)
                                            }
                                    }
                                    .padding(.horizontal, 22)
                                }
                                .scrollIndicators(.hidden)
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
                                        viewModel.selectedCategory = category
                                        showCategoryList = false
                                    } label: {
                                        HStack(spacing: 0) {
                                            Image(category.iconName)
                                                .frame(width: 24, height: 24)
                                                .padding(.horizontal, 12)
                                            
                                            Text(category.title)
                                            
                                            Spacer()
                                            
                                            if category == .NONE {
                                                Image("chevron_up")
                                                    .frame(width: 44, height: 44)
                                            } else {
                                                Color.clear
                                                    .frame(width: 44, height: 44)
                                            }
                                        }
                                        .frame(width: 171, height: 44)
                                        .foregroundStyle(
                                            viewModel.selectedCategory == category
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
        }
        .overlay {
            if showNegguInviteAlert {
                Color.bgDimmed
                    .ignoresSafeArea()
                
                NegguInviteAlert(showAlert: $showNegguInviteAlert)
            }
        }
        .onAppear {
            Task {
                for i in selectedClothes.indices {
                    guard let uiImage = await selectedClothes[i].imageUrl.toImage() else { continue }
                    selectedClothes[i].image = uiImage
                }
            }
            
            viewModel.filteredClothes(inviteCode: inviteCode)
        }
        .onDisappear {
            viewModel.resetLookBookClothes()
        }
    }
    
    var collageView: some View {
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
    
    func makeWaterMarkView(proxy: GeometryProxy) -> some View {
        collageView
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(.white)
            .overlay(alignment: .bottom) {
                VStack {
                    Image("neggu_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 22)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(height: 30)
                        .overlay {
                            HStack {
                                Text("네가 좀 꾸며줘")
                                    .foregroundStyle(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                }
            }
    }
}

extension View {
    
    @MainActor
    func snapshot(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.uiImage
    }

}
