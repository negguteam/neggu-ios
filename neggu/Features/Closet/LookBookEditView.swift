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
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var angle: Angle = .zero
    @State private var lastAngle: Angle = .zero
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button("취소하기") {
                    
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
                    .fill(.background)
                    .shadow(color: .black.opacity(0.1), radius: 12, y: -4)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
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
                                        .strokeBorder(lineWidth: 8)
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
                                        }
                                        .offset(
                                            x: proxy.size.width / 2 * clothes.wrappedValue.scale / 2,
                                            y: proxy.size.height / 2 * clothes.wrappedValue.scale / 2
                                        )
                                        .rotationEffect(clothes.wrappedValue.angle)
                                        .gesture(
                                            rotationGesture(clothes)
//                                            SimultaneousGesture(
//                                                scaleGesture(clothes),
//                                                rotationGesture(clothes)
//                                            )
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
//            .background(.gray)
            .onTapGesture {
                editingClothes = ""
            }
        }
        .clipped()
    }
    
    func drag(clothes: Binding<ClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                guard editingClothes == clothes.id else { return }
                // TODO: [!] 기기마다 알맞게 범위 설정
//                if value.location.y < 0 || value.location.y > 400 { return }
                clothes.wrappedValue.offset = clothes.wrappedValue.lastOffset + value.translation
            }
            .onEnded { _ in
                clothes.wrappedValue.lastOffset = clothes.wrappedValue.offset
            }
    }
    
    func scaleGesture(_ clothes: Binding<ClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let scaleValue = max(value.translation.width, value.translation.height) / 100.0
                // TODO: [!] 최소, 최대 확대 범위 설정
                clothes.wrappedValue.scale = max(0.5, clothes.wrappedValue.lastScale + scaleValue)
//                scale = max(lastScale + value.magnification - (lastScale == 0 ? 0 : 1), 0.05)
            }
            .onEnded { value in
                clothes.wrappedValue.lastScale = clothes.wrappedValue.scale
                
                print(clothes.wrappedValue.angle, clothes.wrappedValue.lastAngle)
                print(value.translation)
            }
    }
    
    func rotationGesture(_ clothes: Binding<ClothesItem>) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let center = CGPoint(x: 0, y: 0) // 뷰의 중심 좌표
                let currentPoint = value.location
                let previousPoint = CGPoint(x: currentPoint.x - value.translation.width,
                                            y: currentPoint.y - value.translation.height)
                
                // 중심과 현재/이전 좌표 간 각도 계산
                let angleValue = angleBetween(center: center, pointA: previousPoint, pointB: currentPoint)
                
                clothes.wrappedValue.angle = clothes.wrappedValue.lastAngle + angleValue
            }
            .onEnded { _ in
                clothes.wrappedValue.lastAngle = clothes.wrappedValue.angle
//                print(clothes.wrappedValue.angle, clothes.wrappedValue.lastAngle)
            }
    }
    
    func angleBetween(center: CGPoint, pointA: CGPoint, pointB: CGPoint) -> Angle {
        let vectorA = CGVector(dx: pointA.x - center.x, dy: pointA.y - center.y)
        let vectorB = CGVector(dx: pointB.x - center.x, dy: pointB.y - center.y)
        
        let dotProduct = vectorA.dx * vectorB.dx + vectorA.dy * vectorB.dy
        let magnitudeA = sqrt(vectorA.dx * vectorA.dx + vectorA.dy * vectorA.dy)
        let magnitudeB = sqrt(vectorB.dx * vectorB.dx + vectorB.dy * vectorB.dy)
        let cosineAngle = dotProduct / (magnitudeA * magnitudeB)
        
        var angle = acos(min(max(cosineAngle, -1.0), 1.0))
        let crossProduct = vectorA.dx * vectorB.dy - vectorA.dy * vectorB.dx
        print(angle)

        return Angle(radians: crossProduct >= 0 ? angle : -angle)
//        return Angle(radians: angle)
    }
}

extension CGSize {
    
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
}

#Preview {
    LookBookEditView()
}
