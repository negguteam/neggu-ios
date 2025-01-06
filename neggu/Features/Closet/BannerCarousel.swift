//
//  BannerCarousel.swift
//  neggu
//
//  Created by 유지호 on 11/13/24.
//

import SwiftUI

struct BannerItem: Identifiable {
    let id: String = UUID().uuidString
    let color: Color
}

struct BannerCarousel: View {
    //    @ViewBuilder let content: Content
    
    @Binding var scrollPosition: Int?
    
        let bannerCount: Int = 2
//    let bannerList: [BannerItem] = [
//        .init(color: .red),
//        .init(color: .blue),
//        .init(color: .green)
//    ]
    
    var body: some View {
        VStack(spacing: 36) {
            GeometryReader { proxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
//                        ForEach(bannerList.indices, id: \.self) { index in
//                            bannerList[index].color
//                                .padding(.horizontal, 20)
//                                .frame(width: proxy.size.width)
//                                .id(index)
//                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("오늘 입을 룩북이")
                                
                                Text("1벌 ")
                                    .foregroundStyle(.orange40)
                                +
                                Text("있어요")
                                
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .fontWeight(.light)
                                    .frame(width: 54, height: 30)
                            }
                            
                            Spacer()
                        }
                        .negguFont(.title4)
                        .foregroundStyle(.labelAlt)
                        .padding(28)
                        .background {
                            Color.white
                                .overlay {
                                    HStack {
                                        Spacer()
                                        
                                        Image(.dummyLookbook)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 150)
                                    }
                                    .padding(28)
                                }
                        }
                        .clipShape(.rect(cornerRadius: 24))
                        .padding(.horizontal, 20)
                        .frame(width: proxy.size.width)
                        .id(0)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("빠르게 옷장에\n담아보세요!")
                                    .negguFont(.title4)
                                    .foregroundStyle(.white)
                                
                                Text("링크를 붙여넣어 내 옷장에 저장할 수 있어요")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }
                        .negguFont(.title4)
                        .foregroundStyle(.labelAlt)
                        .padding(28)
                        .background {
                            Color.black
                                .overlay {
                                    HStack {
                                        Spacer()
                                        
                                        Image(.bannerBG1)
                                            .frame(width: 150)
                                    }
                                    .padding(28)
                                }
                        }
                        .clipShape(.rect(cornerRadius: 24))
                        .padding(.horizontal, 20)
                        .frame(width: proxy.size.width)
                        .id(1)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollPosition)
                .scrollIndicators(.hidden)
            }
            .frame(height: 172)
            
            HStack(spacing: 4) {
//                ForEach(bannerList.indices, id: \.self) { index in
                ForEach(0..<bannerCount, id: \.self) { index in
                    Capsule()
                        .fill(scrollPosition == index ? .black : .systemInactive)
                        .frame(
                            width: scrollPosition == index ? 24 : 8,
                            height: 8
                        )
                        .onTapGesture {
                            scrollPosition = index
                        }
                }
            }
        }
        .animation(.smooth, value: scrollPosition)
    }
}

#Preview {
    ClosetView()
}
