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
    var rotation: Angle = .degrees(0)
    var lastRotation: Angle = .degrees(0)
    var isEditing: Bool = false
    var isSelected: Bool = false
}

struct LookBookView: View {
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
    
//    @State private var selectedClothes: [ClothesItem] = []
    @State private var order: String = "최신 순"
    
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    @State private var scaleOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 16) {
            collageView
            
            Spacer()
            
            HStack {
                HStack {
                    Circle()
                        .frame(width: 21, height: 21)
                    
                    Text("전체 보기")
                }
                .foregroundStyle(.white)
                .padding(10)
                .background {
                    Capsule()
                        .fill(.gray70)
                        .strokeBorder(.black)
                }
                
                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .fill(.gray70)
                        .frame(width: 33.6)
                        .overlay {
                            Text("상의")
                                .foregroundStyle(.white)
                                .font(.system(size: 11))
                        }
                }
                
                Spacer()
            }
            .padding(.horizontal, 25)
            
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
                            //                        .frame(width: proxy.size.width / 2 * scale, height: proxy.size.height / 2 * scale)
                            .frame(width: proxy.size.width / 2, height: proxy.size.height / 2)
                            .scaleEffect(scale)
                            
                            Rectangle()
                                .strokeBorder(lineWidth: 1)
//                                .padding(12)
                                .frame(width: proxy.size.width / 2 * scale, height: proxy.size.height / 2 * scale)
                            
                            HStack {
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Image(systemName: "multiply")
                                        .foregroundStyle(.white)
                                        .padding(4)
                                        .background {
                                            Circle()
                                        }
                                        .onTapGesture {
                                            clothes.wrappedValue.isSelected = false
                                        }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.left.and.right")
                                        .foregroundStyle(.white)
                                        .rotationEffect(.degrees(45))
                                        .padding(4)
                                        .background {
                                            Circle()
                                        }
                                        .gesture(scaleGesture)
                                }
                            }
                        }
                        .overlay {
                            
                        }
                        .offset(offset)
                        .gesture(drag)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .clipped()
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
//                if value.location.y <= -136 || value.location.y >= 328 { return }
                offset = lastOffset + value.translation
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
    
    var scaleGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                scaleOffset = .init(width: value.translation.width, height: value.translation.height)
                let value = max(value.translation.width, value.translation.height) / 100.0
                scale = max(0.5, lastScale + value)
//                scale = max(lastScale + value.magnification - (lastScale == 0 ? 0 : 1), 0.05)
            }
            .onEnded { value in
                lastScale = scale
            }
    }
}

extension CGSize {
    
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
}

#Preview {
    LookBookView()
}
