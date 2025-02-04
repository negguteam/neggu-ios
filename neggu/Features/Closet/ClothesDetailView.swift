//
//  ClothesDetailView.swift
//  neggu
//
//  Created by 유지호 on 11/7/24.
//

import SwiftUI
import Combine

struct ClothesDetailView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    let service: ClosetService = DefaultClosetService()
    let clothesID: String
    
    @State private var clothesState: ClothesState = .loading
    @State private var clothesText: String = ""
    
    @State private var bag = Set<AnyCancellable>()
    
    var body: some View {
        Group {
            switch clothesState {
            case .loading:
                ProgressView()
                    .onAppear {
                        service.clothesDetail(id: clothesID)
                            .sink { event in
                                print("ClosetDetail:", event)
                            } receiveValue: { clothes in
                                clothesState = .loaded(clothes: clothes)
                            }.store(in: &bag)
                    }
            case .loaded(let clothes):
                GeometryReader { proxy in
                    ScrollView {
                        AsyncImage(url: URL(string: clothes.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray10
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .frame(width: proxy.size.width)
                        .aspectRatio(6/5, contentMode: .fit)
                        
                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                Button {
                                    
                                } label: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.labelAlt)
                                        .frame(height: 48)
                                        .overlay {
                                            HStack(spacing: 4) {
                                                Text("공유하기")
                                                
                                                Image(systemName: "square.and.arrow.down")
                                            }
                                            .negguFont(.body1b)
                                            .foregroundStyle(.white)
                                        }
                                }
                                
                                Button {
                                    coordinator.fullScreenCover = .lookbookEdit
                                } label: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.negguSecondary)
                                        .frame(height: 48)
                                        .overlay {
                                            HStack(spacing: 4) {
                                                Text("룩북 만들기")
                                                
                                                Image(.shirtFill)
                                            }
                                            .negguFont(.body1b)
                                            .foregroundStyle(.labelNormal)
                                        }
                                }
                            }
                            
                            Text(clothes.name)
                            Text([clothes.category.title, clothes.subCategory.title].joined(separator: " > "))
                            Text(clothes.mood.map { $0.title }.joined(separator: ", "))
                            Text(clothes.priceRange.title)
                            Text(clothes.isPurchase ? "구매함" : "구매하지 않음")
                        }
                        .padding(.horizontal, 48)
                    }
                }
            }
        }
        .background(.bgNormal)
    }
    
    enum ClothesState {
        case loading
        case loaded(clothes: ClothesEntity)
    }
}

#Preview {
    ClothesDetailView(clothesID: "abcd")
}
