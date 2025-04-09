//
//  InsightView.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import SwiftUI
import Combine

struct InsightView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: InsightViewModel
    
    @State private var insightState: InsightState = .invalid
    @State private var page: Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    coordinator.pop()
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
            
            switch insightState {
            case .valid(let insight):
                TabView(selection: $page) {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        GeometryReader {
                            let size = $0.size
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 0) {
                                    ForEach(insight.lookBooks) { lookBook in
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(.white)
                                            .padding(.horizontal, 48)
                                            .frame(width: size.width)
                                            .shadow(color: .black.opacity(0.05), radius: 4, x: 4, y: 4)
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                                            .overlay {
                                                AsyncImage(url: URL(string: lookBook.imageUrl)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .padding()
                                            }
                                            .visualEffect { effect, proxy in
                                                effect
                                                    .scaleEffect(scale(proxy, scale: 0.1), anchor: .trailing)
                                                    .offset(x: minX(proxy))
                                                    .offset(x: excessMinX(proxy, offset: 10))
                                            }
                                            .zIndex(insight.lookBooks.zIndex(lookBook))
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .scrollTargetBehavior(.paging)
                            .scrollClipDisabled()
                        }
                        .frame(height: 390)
                        
                        Spacer()
                        
                        Text("\(insight.mood.title)에 관심이 많은\n\(insight.nickname)님")
                            .negguFont(.title3)
                            .foregroundStyle(.labelNormal)
                            .multilineTextAlignment(.center)
                    }
                    .tag(0)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white)
                            .aspectRatio(3/4, contentMode: .fit)
                            .overlay {
                                AsyncImage(url: URL(string: insight.clothes.first?.imageUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.horizontal)
                            }
                        
                        Spacer()
                        
                        Text("지금까지\n옷을 \(insight.clothCount)벌 수집했어요")
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
                            .overlay {
                                AsyncImage(url: URL(string: insight.lookBooks.first?.imageUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .padding(.horizontal)
                            }
                        
                        Spacer()
                        
                        Text("지금까지\n룩북을 \(insight.lookBookCount)벌 코디했어요")
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
            case .invalid:
                ProgressView()
                    .onAppear {
                        viewModel.getInsight { insight in
                            self.insightState = .valid(insight)
                        }
                    }
            }
        }
        .padding(.bottom, 8)
        .background(.bgNormal)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    nonisolated func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    nonisolated func progress(_ proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let progress = (maxX / width) - 1.0
        return min(progress, limit)
    }
    
    nonisolated func scale(_ proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy)
        return 1 - (progress * scale)
    }
    
    nonisolated func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy)
        return progress * offset
    }
    
    enum InsightState {
        case valid(InsightEntity)
        case invalid
    }
}

#Preview {
    InsightView()
}


extension [LookBookEntity] {
    
    func zIndex(_ item: LookBookEntity) -> CGFloat {
        if let index = firstIndex(where: { $0.id == item.id }) {
            return CGFloat(count - index)
        }
        
        return .zero
    }
    
}
