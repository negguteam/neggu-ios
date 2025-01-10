//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI

struct LookBookView: View {
    @EnvironmentObject private var lookbookCoordinator: MainCoordinator
    
    @State private var scrollOffset: CGFloat = .zero
    
    let minimumHeaderHeight: CGFloat = 48
    
    var body: some View {
        GeometryReader { proxy in
            let headerHeight: CGFloat = proxy.size.width * 0.4 + minimumHeaderHeight + 20 * 2 + 28
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 20) {
                            Circle()
                                .frame(
                                    width: proxy.size.width * 0.4,
                                    height: proxy.size.width * 0.4
                                )
                            
                            Capsule()
                                .fill(.white)
                                .frame(width: 180, height: 28)
                                .overlay {
                                    Text("뱃지 영역")
                                        .negguFont(.body2b)
                                        .foregroundStyle(.labelAlt)
                                }
                            
                            Text("홍길동의 룩북")
                                .negguFont(.title2)
                                .foregroundStyle(.labelNormal)
                                .frame(height: 48)
                        }
                        .padding(.top, 68)
                        
                        VStack(spacing: 14) {
                            HStack(spacing: 14) {
                                VStack {
                                    Text("의상")
                                        .negguFont(.body3)
                                        .foregroundStyle(.labelAssistive)
                                    
                                    Text("9벌")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelAlt)
                                }
                                .frame(width: 80)
                                
                                Rectangle()
                                    .fill(.lineAlt)
                                    .frame(width: 1, height: 40)
                                
                                VStack {
                                    Text("룩북")
                                        .negguFont(.body3)
                                        .foregroundStyle(.labelAssistive)
                                    
                                    Text("12개")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelAlt)
                                }
                                .frame(width: 80)
                                
                                Rectangle()
                                    .fill(.lineAlt)
                                    .frame(width: 1, height: 40)
                                
                                VStack {
                                    Text("좋아하는")
                                        .negguFont(.body3)
                                        .foregroundStyle(.labelAssistive)
                                    
                                    Text("스트릿")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelAlt)
                                }
                                .frame(width: 80)
                            }
                            .frame(height: 60)
                            .padding(.horizontal, 12)
                            
                            Button {
                                
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.labelAssistive)
                                    .frame(width: 320, height: 48)
                                    .overlay {
                                        HStack {
                                            Text("취향 분석 더보기")
                                                .negguFont(.body2b)
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        .foregroundStyle(.labelRNormal)
                                    }
                            }
                        }
                        .padding(8)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20))
                        
                        VStack(alignment: .leading) {
                            Text("예약된 룩북")
                                .negguFont(.title4)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(0..<5, id: \.self) { index in
                                        let date = Calendar.current.date(byAdding: .day, value: index, to: .now)!
                                        let (dateString, dateColor) = date.generateLookBookDate()
                                        
                                        Button {
                                            lookbookCoordinator.push(.lookbookDetail)
                                        } label: {
                                            LookBookCell(dateString: dateString, dateColor: dateColor)
                                        }
                                    }
                                    
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.negguSecondaryAlt)
                                        .strokeBorder(
                                            .negguSecondary,
                                            style: StrokeStyle(
                                                lineWidth: 2,
                                                dash: [4, 4])
                                        )
                                        .frame(width: 90, height: 120)
                                        .overlay {
                                            VStack {
                                                Image(systemName: "alarm")
                                                    .frame(width: 24, height: 24)
                                                
                                                Text("예약하기")
                                                    .negguFont(.body3b)
                                            }
                                            .foregroundStyle(.negguSecondary)
                                        }
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading) {
                            Text("모든 룩북")
                                .negguFont(.title4)
                            
                            HStack {
                                Text("최신순")
                                    .padding(8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.gray10)
                                    }
                                
                                Text("분위기")
                                    .padding(8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.gray10)
                                    }
                                
                                Spacer()
                            }
                            .negguFont(.body3b)
                            .foregroundStyle(.gray50)
                        }
                        
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(.flexible(), spacing: 16), count: 2),
                            spacing: 16
                        ) {
                            ForEach(0..<8, id: \.self) { index in
                                let date = Calendar.current.date(byAdding: .day, value: index, to: .now)!
                                let (dateString, dateColor) = date.generateLookBookDate()
                                
                                Button {
                                    lookbookCoordinator.push(.lookbookDetail)
                                } label: {
                                    LookBookCell(dateString: dateString, dateColor: dateColor, isNeggu: index % 4 == 0, isGridItem: true)
                                }
                            }
                        }
                    }
                    .id("ScrollView")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 56)
                    .background {
                        ScrollDetector { scrollOffset = -$0 }
                    }
                }
                .background(.gray5)
                .scrollIndicators(.hidden)
                .overlay(alignment: .top) {
                    HStack(spacing: 20) {
                        Group {
                            Circle()
                                .frame(width: 48, height: 48)
                            
                            Text("홍길동의 룩북")
                                .negguFont(.title4)
                                .foregroundStyle(.labelNormal)
                        }
                        .opacity(-scrollOffset >= (headerHeight - minimumHeaderHeight) ? 1 : 0)
                        
                        Spacer()
                        
                        Menu {
                            Button("환경설정") {
                                
                            }
                            
                            Button("프로필 편집") {
                                
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .bold()
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .frame(height: minimumHeaderHeight)
                    .padding(.horizontal, 20)
                    .background(.gray5)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
