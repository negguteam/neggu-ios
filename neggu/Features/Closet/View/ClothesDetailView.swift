//
//  ClothesDetailView.swift
//  neggu
//
//  Created by 유지호 on 11/7/24.
//

import SwiftUI

struct ClothesDetailView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @StateObject private var viewModel: ClothesDetailViewModel = ClothesDetailViewModel()
    
    @State private var showAlert: Bool = false
    
    let clothesID: String
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .initial:
                ProgressView()
                    .onAppear {
                        viewModel.send(action: .fetchClothes(id: clothesID))
                    }
            case .loaded(let clothes):
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        
                        Menu {
                            Button("삭제하기", role: .destructive) {
                                showAlert = true
                            }
                        } label: {
                            Image(.hamburgerHorizontal)
                                .frame(width: 44, height: 44)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding([.horizontal, .top], 20)
                    
                    ScrollView {
                        VStack(spacing: 48) {
                            VStack(alignment: .leading, spacing: 24) {
                                CachedAsyncImage(clothes.imageUrl)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 300)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(clothes.name)
                                        .negguFont(.title3)
                                        .foregroundStyle(.labelNormal)
                                    
                                    Text(clothes.categoryString)
                                        .negguFont(.body2)
                                        .foregroundStyle(.labelAlt)
                                }
                            }
                            
                            VStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("종류")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelNormal)
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(.lineAlt)
                                        .frame(height: 56)
                                        .overlay(alignment: .leading) {
                                            Text(clothes.moodString)
                                                .negguFont(.body2b)
                                                .foregroundStyle(.labelAlt)
                                                .padding(.horizontal, 16)
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("브랜드")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelNormal)
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(.lineAlt)
                                        .frame(height: 56)
                                        .overlay(alignment: .leading) {
                                            Text(clothes.brand)
                                                .negguFont(.body2b)
                                                .foregroundStyle(.labelAlt)
                                                .padding(.horizontal, 16)
                                        }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("가격 및 구매처")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.labelNormal)
                                    
                                    VStack(spacing: 12) {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(.lineAlt)
                                            .frame(height: 56)
                                            .overlay(alignment: .leading) {
                                                Text(clothes.priceRange.title)
                                                    .negguFont(.body2b)
                                                    .foregroundStyle(.labelAlt)
                                                    .padding(.horizontal, 16)
                                            }
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(.lineAlt)
                                            .frame(height: 56)
                                            .overlay {
                                                HStack(spacing: 16) {
                                                    Image(.link)
                                                        .foregroundStyle(.labelAssistive)
                                                        .frame(width: 24, height: 24)
                                                        .padding(.leading, 8)
                                                    
                                                    Text(clothes.link.isEmpty ? "구매 링크" : clothes.link)
                                                        .negguFont(.caption)
                                                        .foregroundStyle(.labelInactive)
                                                        .lineLimit(1)
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                    
                                                    Button {
                                                        
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(.black)
                                                            .frame(width: 40, height: 40)
                                                            .overlay {
                                                                Image(.arrowRight)
                                                                    .foregroundStyle(.white)
                                                            }
                                                    }
                                                }
                                                .padding(.horizontal, 8)
                                            }
                                        
                                        Text(clothes.memo.isEmpty ? "메모를 남겨보세요!" : clothes.memo)
                                            .negguFont(.body2b)
                                            .foregroundStyle(.labelAlt)
                                            .multilineTextAlignment(.leading)
                                            .padding()
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background {
                                                RoundedRectangle(cornerRadius: 16)
                                                    .strokeBorder(.lineAlt)
                                            }
                                    }
                                }
                            }
                            
                            Button {
//                                viewModel.send(action: .onTapModify(
//                                    clothes: <#T##ClothesEntity#>,
//                                    completion: { }
//                                ))
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.negguSecondary)
                                    .frame(height: 56)
                                    .overlay {
                                        Text("수정하기")
                                            .negguFont(.body1b)
                                            .foregroundStyle(.labelRNormal)
                                    }
                            }
                        }
                        .padding(.horizontal, 48)
                        .padding(.bottom, 20)
                    }
                }
                .negguAlert(
                    showAlert: $showAlert,
                    title: "의상을 삭제할까요?",
                    description: "삭제한 의상은 복구되지 않습니다.",
                    leftContent: "취소하기",
                    rightContent: "삭제하기"
                ) {
                    viewModel.send(action: .onTapDelete(
                        id: clothesID,
                        completion: {
                            closetViewModel.send(action: .refresh)
                            coordinator.sheet = nil
                        }
                    ))
                }
            }
        }
        .background(.bgNormal)
    }
}
