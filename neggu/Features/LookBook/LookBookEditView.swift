//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 9/7/24.
//

import SwiftUI
import Combine

struct LookBookEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedClothes: [LookBookClothesItem]
    
    @State private var editingClothes: String = "" {
        didSet {
            isEditingMode = !editingClothes.isEmpty
        }
    }
    
    @State private var selectedCategory: Category = .NONE
    @State private var selectedColor: ColorFilter?
    
    @State private var showCategoryList: Bool = false
    @State private var isColorEditMode: Bool = false
    @State private var isEditingMode: Bool = false
    
    let lookbookService = DefaultLookBookService()
    
    @State private var lookbookClothes: [ClothesEntity] = []
    
    @State private var bag = Set<AnyCancellable>()
    
    init(editingClothes: [LookBookClothesItem] = []) {
        self.selectedClothes = editingClothes
    }
    
    var body: some View {
        GeometryReader { proxy in
            collageView
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [.white, .white, .gray10]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
                .clipped()
                .overlay {
                    VStack(spacing: 0) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(.xLarge)
                                    .frame(width: 44, height: 44)
                            }
                            
                            Spacer()
                            
                            Button("저장하기") {
                                guard let lookbookImage = collageView
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .snapshot(),
                                      let pngData = lookbookImage.pngData()
                                else { return }
                                
                                let requests = selectedClothes.compactMap { $0.toEntity() }
                                debugPrint(requests)
                                
                                lookbookService.register(
                                    image: pngData,
                                    request: requests
                                ).sink { event in
                                    print("LookBookEditView", event)
                                } receiveValue: { result in
                                    debugPrint(result)
                                    dismiss()
                                }.store(in: &bag)
                            }
                            .negguFont(.body2b)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                        .foregroundStyle(.black)
                        .opacity(isEditingMode ? 0 : 1)
                        .disabled(isEditingMode)
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                print("네꾸하기")
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
                        .opacity(isEditingMode ? 0 : 1)
                        .disabled(isEditingMode)
                        
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
                                                Image(selectedCategory.iconName)
                                                
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
                                                        selectedColor = nil
                                                        isColorEditMode = false
                                                    }
                                                
                                                ForEach(ColorFilter.allCases) { filter in
                                                    Circle()
                                                        .stroke(.lineAlt)
                                                        .fill(filter.color)
                                                        .frame(width: 32)
                                                        .onTapGesture {
                                                            selectedColor = filter
                                                            isColorEditMode = false
                                                        }
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                        .opacity(isColorEditMode ? 1 : 0)
                                    } else {
                                        if let selectedColor {
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
                                    HStack {
                                        ForEach($lookbookClothes) { clothes in
                                            let isSelected = selectedClothes.contains(where: { $0.id == clothes.id })
                                            
                                            Button {
                                                if !isSelected {
                                                    let middleX = proxy.size.width / 4
                                                    let middleY = proxy.size.height / 4
                                                    selectedClothes.append(clothes.wrappedValue.toLookBookItem(offset: .init(width: middleX, height: middleY)))
                                                } else {
                                                    selectedClothes.removeAll(where: { $0.id == clothes.wrappedValue.id })
                                                }
                                            } label: {
                                                AsyncImage(url: URL(string: clothes.wrappedValue.imageUrl)) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 100, height: 100)
                                                .background(isSelected ? .negguSecondaryAlt : .gray5)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .strokeBorder(isSelected ? .negguSecondary : .gray5)
                                                }
                                                .clipShape(.rect(cornerRadius: 16))
                                            }
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
                                        selectedCategory = category
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
                                            selectedCategory == category
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
        .onAppear {
            getLookBookClothes()
        }
        .onChange(of: selectedCategory) {
            getLookBookClothes()
        }
        .onChange(of: selectedColor) {
            getLookBookClothes()
        }
    }
    
    var collageView: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach($selectedClothes) { clothes in
                    Group {
                        if let image = clothes.wrappedValue.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Color.clear
                                .overlay {
                                    ProgressView()
                                }
                        }
                    }
                    .frame(width: proxy.size.width / 2, height: proxy.size.height / 3)
                    .scaleEffect(clothes.wrappedValue.scale)
                    .rotationEffect(clothes.wrappedValue.angle)
                    .overlay {
                        if editingClothes == clothes.id {
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(
                                    .black,
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [4, 4]
                                    )
                                )
                                .frame(
                                    width: proxy.size.width / 2 * clothes.wrappedValue.scale,
                                    height: proxy.size.height / 3 * clothes.wrappedValue.scale
                                )
                                .rotationEffect(clothes.wrappedValue.angle)
                            
                            Circle()
                                .fill(.negguPrimary)
                                .frame(width: 36, height: 36)
                                .overlay {
                                    Image("resize")
                                        .foregroundStyle(.white)
                                }
                                .offset(
                                    x: proxy.size.width / 2 * clothes.wrappedValue.scale / 2,
                                    y: proxy.size.height / 2 * clothes.wrappedValue.scale / 3
                                )
                                .rotationEffect(clothes.wrappedValue.angle)
                                .gesture(
                                    SimultaneousGesture(
                                        scaleGesture(clothes),
                                        rotationGesture(clothes)
                                    )
                                )
                        }
                    }
                    .offset(clothes.wrappedValue.offset)
                    .zIndex(Double(selectedClothes.firstIndex(where: { $0.id == clothes.wrappedValue.id }) ?? 0))
                    .gesture(drag(clothes: clothes))
                    .onTapGesture {
                        if editingClothes == clothes.id {
                            editingClothes = ""
                        } else {
                            editingClothes = clothes.id
                        }
                        
                        selectedClothes.append(clothes.wrappedValue)
                        
                        guard let index = selectedClothes.firstIndex(where: { $0.id == clothes.wrappedValue.id }) else { return }
                        selectedClothes.remove(at: index)
                        
                        guard let lastIndex = selectedClothes.firstIndex(where: { $0.id == clothes.wrappedValue.id }) else { return }
                        clothes.wrappedValue.zIndex = Double(lastIndex)
                    }
                }
                
                if isEditingMode {
                    Color.white.opacity(0.3)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .zIndex(Double(selectedClothes.count) - 1.5)
                        .onTapGesture {
                            editingClothes = ""
                        }
                }
            }
        }
    }
    
    func getLookBookClothes() {
//        if !canPagenation { return }
                    
        var parameters: [String: Any] = ["page": 0, "size": 10]
        
        if selectedCategory != .UNKNOWN && selectedCategory != .NONE {
            parameters["filterCategory"] = selectedCategory.id
        }
        
        if let selectedColor {
            parameters["colorGroup"] = selectedColor.id
        } else {
            parameters["colorGroup"] = "ALL"
        }
        
        lookbookService.lookbookClothes(parameters: parameters)
            .sink { event in
                print("LookBookEditView:", event)
            } receiveValue: { result in
                self.lookbookClothes = result.content
            }.store(in: &bag)
    }
    
    func drag(clothes: Binding<LookBookClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard editingClothes == clothes.id else { return }
                
                clothes.wrappedValue.offset = clothes.wrappedValue.lastOffset + value.translation
            }
            .onEnded { _ in
                clothes.wrappedValue.lastOffset = clothes.wrappedValue.offset
            }
    }
    
    // TODO: Scasle
    func scaleGesture(_ clothes: Binding<LookBookClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // TODO: [!] 최소, 최대 확대 범위 설정
                let distance = distanceBetween(center: .zero, point: value.location)
                clothes.wrappedValue.scale = max(distance / clothes.wrappedValue.lastScale, 0.1)
            }
            .onEnded { value in
                clothes.wrappedValue.lastScale = clothes.wrappedValue.scale
            }
    }
        
    func distanceBetween(center: CGPoint, point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2)) / 200
    }
    
    // TODO: 편집 시 각도 인식 이슈 해결하기
    func rotationGesture(_ clothes: Binding<LookBookClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // 드래그 시작 시 기준 각도를 설정
                if clothes.wrappedValue.lastAngle == .degrees(0) {
                    clothes.wrappedValue.lastAngle = angleForPoint(start: .zero, end: value.location)
                }
                
                // 현재 각도와 시작 각도 비교하여 각도 변화 계산
                var angle = angleForPoint(start: .zero, end: value.location) - clothes.wrappedValue.lastAngle
                
                if angle.degrees < 0 {
                    angle.degrees += 360
                }
            
                if angle.degrees > 360 {
                    angle.degrees -= 360
                }
                
                clothes.wrappedValue.angle = angle
            }
            .onEnded { _ in
                print(clothes.wrappedValue.angle.degrees)
            }
    }
    
    func angleForPoint(start: CGPoint, end: CGPoint) -> Angle {
        let deltaX = end.x - start.x
        let deltaY = end.y - start.y
        let radians = atan2(deltaY, deltaX)
        let degrees = radians * 180 / .pi
        return Angle(degrees: degrees)
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

#Preview {
    LookBookEditView()
}
