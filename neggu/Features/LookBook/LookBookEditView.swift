//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 9/7/24.
//

import SwiftUI

struct LookBookEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var clothes: [Clothes] = [
        .init(
            name: "루즈핏 V넥 베스트 CRYSTAL BEIGE",
            link: "https://musinsaapp.page.link/v1St9cWw5h291zfBA",
            imageUrl: "https://image.msscdn.net/images/goods_img/20230809/3454995/3454995_16915646154097_500.jpg",
            brand: "내셔널지오그래픽"
        ),
        .init(
            name: "나이키 에어포스 1 '07 LV8 미드나잇 네이비",
            link: "https://kream.co.kr/products/78768?base_product_id=12831",
            imageUrl: "https://kream-phinf.pstatic.net/MjAyNDA2MjJfMTMx/MDAxNzE5MDI5ODMzOTg2.8TsdHQrXy3-tcIMHceZOG5eBSdl_-ybtjFhLVIZDOXEg.TUQIZNOi5ptP4zsfcdsi3EBAgTwh2jruSeKGnbMekaQg.PNG/a_56586590956f4404862cbdaeff6a5e63.png",
            brand: "Nike"
        ),
        .init(
            name: "푸마 터프 테라 Mid Gloss - 블랙: 다크그레이",
            link: "https://www.musinsa.com/products/4537667",
            imageUrl: "https://image.msscdn.net/thumbnails/images/goods_img/20241021/4537667/4537667_17302782606169_500.jpg",
            brand: "puma"
        )
    ]
    
    @State private var selectedClothes: [Clothes] = []
    
    @State private var editingClothes: String = "" {
        didSet {
            isEditingMode = !editingClothes.isEmpty
        }
    }
    
    @State private var selectedCategory: String = "전체"
    
    @State private var showCategoryList: Bool = false
    @State private var isColorEditMode: Bool = false
    @State private var isEditingMode: Bool = false
    
    private let categories: [String] = ["상의", "하의", "아우터", "원피스", "기타", "전체"]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "multiply")
                            .frame(width: 24, height: 24)
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Spacer()
                        
                        // TODO: 사진 저장 시, placehoder로 저장되는 것 해결하기
                        Button("저장하기") {
                            guard let lookbookImage = makeWaterMarkView(proxy: proxy).snapshot() else { return }
                            UIImageWriteToSavedPhotosAlbum(lookbookImage, nil, nil, nil)
                        }
                        .negguFont(.body2b)
                        .foregroundStyle(.black)
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    
                    collageView
                        .frame(width: proxy.size.width, height: proxy.size.height - 44)
                        .clipped()
                }
            }
            
            VStack(spacing: 0) {
                if !isEditingMode {
                    HStack {
                        HStack {
                            if !isColorEditMode {
                                Button {
                                    showCategoryList = true
                                } label: {
                                    HStack(spacing: 0) {
                                        Image(systemName: "globe")
                                        
                                        HStack(spacing: 0) {
                                            Text("길동")
                                                .lineLimit(1)
                                            
                                            Text("의 옷장")
                                                .fixedSize()
                                        }
                                        .padding(.horizontal, 12)
                                        
                                        Image(systemName: showCategoryList ? "chevron.down" : "chevron.up")
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
                                
                                Button {
                                    
                                } label: {
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(.negguSecondary)
                                        .frame(width: 80, height: 44)
                                        .overlay {
                                            Text("네꾸 ✨")
                                                .negguFont(.body2b)
                                                .foregroundStyle(.white)
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
                                        Circle()
                                            .frame(width: 32)
                                        
                                        ForEach(ColorFilter.allCases) { filter in
                                            Circle()
                                                .stroke(.lineAlt)
                                                .fill(filter.color)
                                                .frame(width: 32)
                                        }
                                    }
                                }
                                .scrollIndicators(.hidden)
                                .opacity(isColorEditMode ? 1 : 0)
                            } else {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 24)
                                    .opacity(isColorEditMode ? 0 : 1)
                            }
                            
                            Button {
                                isColorEditMode.toggle()
                            } label: {
                                Image(systemName: "chevron.down")
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
                } else {
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
                }
                
                UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24)
                    .fill(.white)
                    .frame(height: isEditingMode ? 18 : 152)
                    .overlay(alignment: .top) {
                        if !isEditingMode {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach($clothes) { clothes in
                                        let isSelected = selectedClothes.contains(where: { $0.id == clothes.id })
                                        
                                        Button {
                                            if !isSelected {
                                                selectedClothes.append(clothes.wrappedValue)
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
                                .padding(.horizontal, 20)
                            }
                            .scrollIndicators(.hidden)
                            .padding(.top, 30)
                        }
                    }
            }
            
            if showCategoryList {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        showCategoryList = false
                    }
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            selectedCategory = category
                            showCategoryList = false
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "globe")
                                
                                Text(category)
                                
                                Spacer()
                                
                                if category == "전체" {
                                    Image(systemName: showCategoryList ? "chevron.down" : "chevron.up")
                                }
                            }
                            .frame(width: 146, height: 44)
                            .foregroundStyle(
                                selectedCategory == category
                                ? .negguSecondary
                                : .labelInactive
                            )
                        }
                    }
                }
                .negguFont(.body2b)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(.white)
                }
                .padding(.leading, 20)
                .padding(.bottom, 172)
            }
        }
        .background {
            LinearGradient(
                gradient: Gradient(colors: [.white, .white, .gray10]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var collageView: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach($selectedClothes) { clothes in
                    AsyncImage(url: URL(string: clothes.wrappedValue.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        default:
                            Color.clear
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
                                    Image(systemName: "arrow.left.and.right")
                                        .foregroundStyle(.white)
                                }
                                .rotationEffect(.degrees(45))
                                .offset(
                                    x: proxy.size.width / 2 * clothes.wrappedValue.scale / 2 + 18,
                                    y: proxy.size.height / 2 * clothes.wrappedValue.scale / 3 + 2
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
                    .zIndex(Double(selectedClothes.firstIndex(of: clothes.wrappedValue) ?? 0))
                    .gesture(drag(clothes: clothes))
                    .onTapGesture {
                        if editingClothes == clothes.id {
                            editingClothes = ""
                        } else {
                            editingClothes = clothes.id
                        }
                        
                        selectedClothes.append(clothes.wrappedValue)
                        
                        guard let index = selectedClothes.firstIndex(where: { $0 == clothes.wrappedValue }) else { return }
                        selectedClothes.remove(at: index)
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
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    func drag(clothes: Binding<Clothes>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard editingClothes == clothes.id else { return }
                
                clothes.wrappedValue.offset = clothes.wrappedValue.lastOffset + value.translation
            }
            .onEnded { _ in
                clothes.wrappedValue.lastOffset = clothes.wrappedValue.offset
            }
    }
    
    func scaleGesture(_ clothes: Binding<Clothes>) -> some Gesture {
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
    
    func rotationGesture(_ clothes: Binding<Clothes>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // 드래그 시작 시 기준 각도를 설정
                if clothes.wrappedValue.lastAngle == .degrees(0) {
                    clothes.wrappedValue.lastAngle = angleForPoint(start: .zero, end: value.location)
                }
                
                // 현재 각도와 시작 각도 비교하여 각도 변화 계산
                clothes.wrappedValue.angle = angleForPoint(start: .zero, end: value.location) - clothes.wrappedValue.lastAngle
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
