//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI

struct LookBookView: View {
    @EnvironmentObject private var lookbookCoordinator: MainCoordinator
    
    @State private var offset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 24) {
                        headerView(safeArea: safeArea)
                            .padding(.horizontal, -20)
                            .zIndex(100)
                        
                        VStack(spacing: 14) {
                            HStack(spacing: 14) {
                                VStack {
                                    Text("의상")
                                        .negguFont(.body3)
                                        .foregroundStyle(.labelAssistive)
                                    
                                    Text("9개")
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
                                    .fill(.bgNormal)
                                    .frame(width: 320, height: 48)
                                    .overlay {
                                        HStack {
                                            Text("취향 분석 더보기")
                                                .negguFont(.body2b)
                                            
                                            Image(systemName: "chevron.right")
                                        }
                                        .foregroundStyle(.labelAssistive)
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
                                        
                                        ZStack(alignment: .topTrailing) {
                                            Image(.dummyLookbook)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 90, height: 120)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(.white)
                                                }
                                                .padding(.top, 7)
                                            
                                            Text(date.test())
                                                .negguFont(.caption)
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 12)
                                                .frame(height: 24)
                                                .background {
                                                    UnevenRoundedRectangle(
                                                        topLeadingRadius: 8,
                                                        bottomLeadingRadius: 8,
                                                        topTrailingRadius: 8
                                                    )
                                                    .fill(.negguSecondary)
                                                }
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
                                Button {
                                    lookbookCoordinator.push(.lookbookDetail)
                                } label: {
                                    let date = Calendar.current.date(byAdding: .day, value: index, to: .now)!
                                    
                                    ZStack(alignment: .topTrailing) {
                                        Image(.dummyLookbook)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(10)
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: "alarm")
                                            
                                            Text(date.test())
                                        }
                                        .negguFont(.caption)
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 12)
                                        .frame(height: 24)
                                        .background {
                                            UnevenRoundedRectangle(
                                                topLeadingRadius: 8,
                                                bottomLeadingRadius: 8,
                                                topTrailingRadius: 8
                                            )
                                            .fill(.negguSecondary)
                                        }
                                    }
                                    .background {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.white)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .id("ScrollView")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 56)
                    .background {
                        ScrollDetector { offset in
                            self.offset = -offset
                        } onDraggingEnd: { offset, velocity in
                            let headerHeight: CGFloat = 368 + safeArea.top
                            let minimumHeaderHeight: CGFloat = 60 + safeArea.top
                            let targetEnd = offset + (velocity * 45)
                            
                            if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                                withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                    scrollProxy.scrollTo("ScrollView", anchor: .top)
                                }
                            }
                        }
                    }
                }
                .background(.gray5)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    @ViewBuilder
    func headerView(safeArea: EdgeInsets) -> some View {
        let headerHeight: CGFloat = 368 + safeArea.top
        let minimumHeaderHeight: CGFloat = 48 + safeArea.top
        let progress = max(min(-offset / (headerHeight - minimumHeaderHeight), 1), 0)
        
        GeometryReader { _ in
            VStack(spacing: 16) {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let midY = rect.midY
                    let halfScaledHeight = (rect.height * 0.2) * 0.5
                    let resizedOffset = (midY - (minimumHeaderHeight - halfScaledHeight - 48))
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .bold()
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .frame(height: 48)
                    .offset(y: -resizedOffset * progress)
                }
                
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let halfScaledHeight = (rect.height * 0.2) * 0.5
                    let midY = rect.midY
                    let resizedOffset = (midY - (minimumHeaderHeight - halfScaledHeight - 2))
                    
                    Circle()
                        .fill(.gray10)
                        .frame(width: rect.width, height: rect.height)
                        .scaleEffect(1 - (progress * 0.8), anchor: .leading)
                        .offset(
                            x: -(rect.minX - 20) * progress,
                            y: -resizedOffset * progress
                        )
                }
                .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                
                Text("아메카지 러버")
                    .negguFont(.body2b)
                    .foregroundStyle(.labelNormal)
                
                Text("길동의 룩북")
                    .negguFont(.title2)
                    .scaleEffect(1 - (progress * 0.3))
            }
            .padding(.horizontal, 20)
            .padding(.top, safeArea.top)
            .frame(
                height: (headerHeight + offset) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offset),
                alignment: .bottom
            )
            .background {
                Rectangle()
                    .fill(.clear)
                    .blendMode(.colorBurn)
            }
            .offset(y: -offset)
        }
        .frame(height: headerHeight)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> Void
    var onDraggingEnd: (CGFloat, CGFloat) -> Void
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView,
               !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        
        var isDelegateAdded: Bool = false
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
        
        func scrollViewWillEndDragging(
            _ scrollView: UIScrollView,
            withVelocity velocity: CGPoint,
            targetContentOffset: UnsafeMutablePointer<CGPoint>
        ) {
            parent.onDraggingEnd(targetContentOffset.pointee.y, velocity.y)
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView.panGestureRecognizer.view)
            parent.onDraggingEnd(scrollView.contentOffset.y, velocity.y)
        }
    }
}
