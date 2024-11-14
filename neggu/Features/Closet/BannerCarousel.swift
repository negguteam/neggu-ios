//
//  BannerCarousel.swift
//  neggu
//
//  Created by 유지호 on 11/13/24.
//

import SwiftUI

struct BannerCarousel: View {
    @Binding var scrollID: Int?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
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
                .containerRelativeFrame(.horizontal) { length, _ in length - 40 }
                .frame(height: 172)
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
                .clipShape(.rect(cornerRadius: 36))
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
                .containerRelativeFrame(.horizontal) { length, _ in length - 40 }
                .frame(height: 172)
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
                .clipShape(.rect(cornerRadius: 36))
                .id(1)
            }
            .padding(.horizontal, 20)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
        .animation(.smooth, value: scrollID)
        .scrollIndicators(.hidden)
        .padding(.horizontal, -20)
    }
}

#Preview {
    ClosetView()
}
