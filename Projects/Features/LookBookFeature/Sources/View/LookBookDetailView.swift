//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import Core
import NegguDS
import Networks

import BaseFeature

import SwiftUI

struct LookBookDetailView: View {
    @EnvironmentObject private var coordinator: LookBookCoordinator

    @StateObject private var viewModel: LookBookDetailViewModel
    
    @State private var selectedDate: Date?
    
    @State private var showDateSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showNegguInviteAlert: Bool = false
    
    private let lookBookID: String
    
    init(
        viewModel: LookBookDetailViewModel,
        lookBookID: String
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.lookBookID = lookBookID
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                if let lookBook = viewModel.lookBookDetail {
                    HStack {
                        Button {
                            coordinator.pop()
                        } label: {
                            NegguImage.Icon.chevronLeft
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button("이미지로 저장하기") {
                                Task {
                                    guard let lookBookImage = await lookBook.imageUrl.toImage() else { return }
                                    UIImageWriteToSavedPhotosAlbum(lookBookImage, nil, nil, nil)
                                }
                            }
                            
                            Button("삭제하기", role: .destructive) {
                                showDeleteAlert = true
                            }
                        } label: {
                            NegguImage.Icon.horizontalHamburger
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .background(.bgNormal)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            CachedAsyncImage(lookBook.imageUrl)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 24)
                                .frame(width: size.width, height: size.height * 0.8)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 20))
                            
                            VStack(spacing: 24) {
                                Text((lookBook.modifiedAt.toISOFormatDate()?.toLookBookDetailDateString() ?? "") + " 편집됨")
                                    .negguFont(.caption)
                                    .foregroundStyle(.black.opacity(0.2))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                VStack(spacing: 16) {
                                    Text("의상")
                                        .negguFont(.title3)
                                        .foregroundStyle(.labelNormal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                                        ForEach(lookBook.lookBookClothes) { clothes in
                                            Button {
                                                coordinator.present(.clothesDetail(clothesId: clothes.id))
                                            } label: {
                                                CachedAsyncImage(clothes.imageUrl)
                                                    .aspectRatio(5/6, contentMode: .fit)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 28)
                                .padding(.vertical, 32)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 16))
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 12)
                    }
                    .scrollIndicators(.hidden)
                    .background(.bgNormal)
                } else {
                    HStack {
                        Button {
                            coordinator.pop()
                        } label: {
                            NegguImage.Icon.chevronLeft
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .background(.bgNormal)
                    
                    Color.clear
                        .overlay {
                            ProgressView()
                                .onAppear {
                                    viewModel.viewDidAppear.send(lookBookID)
                                }
                        }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showDateSheet) {
            LookBookDateSheet(selectedDate: $selectedDate)
                .presentationCornerRadius(20)
        }
        .negguAlert(
            .delete(.lookBook),
            showAlert: $showDeleteAlert
        ) {
            viewModel.deleteButtonDidTap.send(lookBookID)
        }
    }
}
