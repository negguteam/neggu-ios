//
//  InsightView.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import SwiftUI

struct InsightView: View {
    @State private var page: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(.chevronLeft)
                        .frame(width: 44)
                }
                
                Spacer()
                
                Text("취향분석")
                    .negguFont(.body1b)
                
                Spacer()
                
                Color.clear
                    .frame(width: 44)
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            .foregroundStyle(.labelNormal)
            
            TabView(selection: $page) {
                VStack(spacing: 0) {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                        .aspectRatio(3/4, contentMode: .fit)
                    
                    Spacer()
                    
                    Text("ㅇㅇ에 관심이 많은\nㅇㅇ님")
                        .negguFont(.title3)
                        .foregroundStyle(.labelNormal)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)
                .tag(0)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                        .aspectRatio(3/4, contentMode: .fit)
                    
                    Spacer()
                    
                    Text("지금까지\n옷을 ㅇㅇ벌 수집했어요")
                        .negguFont(.title3)
                        .foregroundStyle(.labelNormal)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)
                .tag(1)
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                        .aspectRatio(3/4, contentMode: .fit)
                    
                    Spacer()
                    
                    Text("지금까지\n룩북을 ㅇㅇ벌 코디했어요")
                        .negguFont(.title3)
                        .foregroundStyle(.labelNormal)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 48)
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(page == index ? .labelNormal : .labelInactive)
                        .frame(width: page == index ? 24 : 8, height: 8)
                        .onTapGesture {
                            page = index
                        }
                }
            }
            .frame(height: 56)
            .animation(.smooth, value: page)
        }
        .padding(.bottom, 8)
        .background(.bgNormal)
    }
}

#Preview {
    InsightView()
}
