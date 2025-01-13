//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 9/7/24.
//

import SwiftUI

struct ClothesItem: Identifiable {
    var id: String
    var name: String
    var image: String
    var brand: String
    var price: Int
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
    var scale: CGFloat = 1.0
    var lastScale: CGFloat = 1.0
    var angle: Angle = .degrees(0)
    var lastAngle: Angle = .degrees(0)
    var isEditing: Bool = false
    var isSelected: Bool = false
}

struct LookBookEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var categories: [String] = ["전체보기", "상의", "하의", "아우터", "신발", "기타"]
    @State private var clothes: [ClothesItem] = [
        .init(
            id: "https://musinsaapp.page.link/v1St9cWw5h291zfBA",
            name: "루즈핏 V넥 베스트 CRYSTAL BEIGE",
            image: "https://image.msscdn.net/images/goods_img/20230809/3454995/3454995_16915646154097_500.jpg",
            brand: "내셔널지오그래픽",
            price: 79000
        ),
        .init(
            id: "https://kream.co.kr/products/78768?base_product_id=12831",
            name: "나이키 에어포스 1 '07 LV8 미드나잇 네이비",
            image: "https://kream-phinf.pstatic.net/MjAyNDA2MjJfMTMx/MDAxNzE5MDI5ODMzOTg2.8TsdHQrXy3-tcIMHceZOG5eBSdl_-ybtjFhLVIZDOXEg.TUQIZNOi5ptP4zsfcdsi3EBAgTwh2jruSeKGnbMekaQg.PNG/a_56586590956f4404862cbdaeff6a5e63.png",
            brand: "Nike",
            price: 143000
        )
    ]
    
    @State private var editingClothes: String = ""
    
    @State private var selectedCategoryIndex: Int = 0
    
    @State private var order: String = "최신 순"
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("취소하기") {
                    dismiss()
                }
                .foregroundStyle(.red)
                
                Spacer()
                
                Button("다음으로") {
                    
                }
                .foregroundStyle(.black)
            }
            .negguFont(.body2)
            .padding(.horizontal, 20)
            
            collageView
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(categories.indices, id: \.self) { index in
                        let isSelected = selectedCategoryIndex == index
                        
                        HStack {
                            if isSelected {
                                Circle()
                                    .frame(width: 21, height: 21)
                            }
                            
                            Text(categories[index])
                                .negguFont(isSelected ? .body3b : .caption)
                        }
                        .foregroundStyle(.white)
                        .padding(10)
                        .background {
                            Capsule()
                                .fill(isSelected ? .gray70 : .gray70.opacity(0.4))
                                .strokeBorder(isSelected ? .black : .clear)
                        }
                        .onTapGesture {
                            withAnimation(.smooth) {
                                selectedCategoryIndex = index
                            }
                        }
                    }
                }
                .padding(.horizontal, 25)
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Menu {
                        Button("최신 순") {
                            order = "최신 순"
                        }
                        
                        Button("오래된 순") {
                            order = "오래된 순"
                        }
                    } label: {
                        Label(order, systemImage: "arrow.left.arrow.right")
                            .font(.system(size: 14))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(28)
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach($clothes) { clothes in
                            Button {
                                if clothes.wrappedValue.isSelected {
                                    clothes.wrappedValue.isSelected = false
                                } else {
                                    clothes.wrappedValue.isSelected = true
                                    print("\(clothes.wrappedValue.name)")
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(.gray20)
                                    .frame(width: 122, height: 122)
                                    .background {
                                        AsyncImage(url: URL(string: clothes.wrappedValue.image)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .opacity(clothes.wrappedValue.isSelected ? 0.3 : 1.0)
                                    }
                            }
                        }
                        
                        Button {
                            print("의상 추가")
                        } label: {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: .init(dash: [4]))
                                .foregroundStyle(.gray20)
                                .frame(width: 122, height: 122)
                                .overlay {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 36)
                                        .foregroundStyle(.gray20)
                                }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .scrollIndicators(.hidden)
            }
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .shadow(color: .black.opacity(0.1), radius: 12, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
        .background(.white)
    }
    
    var collageView: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach($clothes) { clothes in
                    if clothes.wrappedValue.isSelected {
                        ZStack {
                            AsyncImage(url: URL(string: clothes.wrappedValue.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 2)
                            .onTapGesture {
                                if editingClothes == clothes.id {
                                    editingClothes = ""
                                } else {
                                    editingClothes = clothes.id
                                }
                            }
                            .scaleEffect(clothes.wrappedValue.scale)
                            .rotationEffect(clothes.wrappedValue.angle)
                            .overlay {
                                if editingClothes == clothes.id {
                                    RoundedRectangle(cornerRadius: 18)
                                        .strokeBorder(.black, lineWidth: 8)
                                        .frame(width: proxy.size.width / 2 * clothes.wrappedValue.scale, height: proxy.size.height / 2 * clothes.wrappedValue.scale)
                                        .rotationEffect(clothes.wrappedValue.angle)
                                    
                                    Image(systemName: "multiply")
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background {
                                            Circle()
                                                .fill(.warning)
                                        }
                                        .offset(
                                            x: proxy.size.width / 2 * clothes.wrappedValue.scale / 2,
                                            y: -proxy.size.height / 2 * clothes.wrappedValue.scale / 2
                                        )
                                        .rotationEffect(clothes.wrappedValue.angle)
                                        .onTapGesture {
                                            clothes.wrappedValue.isSelected = false
                                        }
                                    
                                    Image(systemName: "arrow.left.and.right")
                                        .foregroundStyle(.white)
                                        .rotationEffect(.degrees(45))
                                        .padding(4)
                                        .background {
                                            Circle()
                                                .fill(.black)
                                        }
                                        .offset(
                                            x: proxy.size.width / 2 * clothes.wrappedValue.scale / 2,
                                            y: proxy.size.height / 2 * clothes.wrappedValue.scale / 2
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
                        }
                        .offset(clothes.wrappedValue.offset)
                        .gesture(drag(clothes: clothes))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                editingClothes = ""
            }
        }
        .clipped()
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
    
    // 주어진 점과 뷰의 중심 사이의 각도 계산 (degrees)
    func angleForPoint(start: CGPoint, end: CGPoint) -> Angle {
        let deltaX = end.x - start.x
        let deltaY = end.y - start.y
        let radians = atan2(deltaY, deltaX)
        let degrees = radians * 180 / .pi
        return Angle(degrees: degrees)
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
