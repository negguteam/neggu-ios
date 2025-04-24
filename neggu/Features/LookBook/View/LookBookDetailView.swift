//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import SwiftUI

struct LookBookDetailView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var lookBookViewModel: LookBookViewModel
    @ObservedObject private var viewModel: LookBookDetailViewModel
    
    @State private var selectedDate: Date?
    @State private var isPublic: Bool = false
    
    @State private var showDateSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var showNegguInviteAlert: Bool = false
    
    private let lookBookID: String
    
    init(
        viewModel: LookBookDetailViewModel,
        lookBookID: String
    ) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self.lookBookID = lookBookID
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                switch viewModel.state {
                case .initial:
                    HStack {
                        Button {
                            coordinator.pop()
                        } label: {
                            Image(.chevronLeft)
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
                                    viewModel.send(action: .fetchLookBook(id: lookBookID))
                                }
                        }
                case .loaded(let lookBook):
                    HStack {
                        Button {
                            coordinator.pop()
                        } label: {
                            Image(.chevronLeft)
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
                            
//                            Button("편집하기") {
//                                let editingClothes = lookBook.lookBookClothes.map { $0.toLookBookItem() }
//                                coordinator.fullScreenCover = .lookbookRegister(editingClothes: editingClothes)
//                            }
                            
                            Button("삭제하기", role: .destructive) {
                                showDeleteAlert = true
                            }
                        } label: {
                            Image(.hamburgerHorizontal)
                                .foregroundStyle(.labelNormal)
                                .frame(width: 44, height: 44)
                        }
                    }
                    .frame(height: 44)
                    .padding(.horizontal, 20)
                    .background(.bgNormal)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack {
                                CachedAsyncImage(lookBook.imageUrl)
                                    .frame(maxHeight: .infinity)
                                
                                HStack {
                                    if let decorator = lookBook.decorator {
                                        HStack(spacing: 12) {
                                            if let decoratorImage = decorator.imageUrl {
                                                CachedAsyncImage(decoratorImage)
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(.circle)
                                            } else {
                                                Color.negguSecondary
                                                    .frame(width: 24, height: 24)
                                                    .mask {
                                                        Image(.negguStar)
                                                            .foregroundStyle(.negguSecondary)
                                                    }
                                            }
                                            
                                            HStack(spacing: 0) {
                                                Text("친구")
                                                    .foregroundStyle(.negguSecondary)
                                                    .lineLimit(1)
                                                
                                                Text("님이 꾸며줬어요")
                                                    .fixedSize()
                                            }
                                            .negguFont(.body2b)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .padding(.horizontal, 14)
                                        .background(.bgNormal)
                                        .clipShape(.rect(cornerRadius: 16))
                                    } else {
                                        Spacer()
                                    }
                                    
                                    Button {
                                        showDateSheet = true
                                    } label: {
                                        HStack(spacing: 4) {
                                            Image(.calendar)
                                                .frame(width: 24, height: 24)
                                            
                                            if let selectedDate {
                                                Text(selectedDate.monthDayFormatted())
                                            }
                                        }
                                        .negguFont(.body2b)
                                        .foregroundStyle(selectedDate == nil ? .labelInactive : .negguSecondary)
                                        .padding(.horizontal, 12)
                                        .frame(width: selectedDate == nil ? 56 : nil, height: 56)
                                        .background(.bgNormal)
                                        .clipShape(.rect(cornerRadius: 16))
                                    }
                                }
                            }
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
                                
                                VStack {
                                    Text("더보기")
                                        .negguFont(.title3)
                                        .foregroundStyle(.labelNormal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()), count: 4)) {
                                        ForEach(lookBook.lookBookClothes) { clothes in
                                            Button {
                                                coordinator.sheet = .clothesDetail(id: clothes.id)
                                            } label: {
                                                CachedAsyncImage(clothes.imageUrl)
                                                    .aspectRatio(1, contentMode: .fit)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 28)
                                .padding(.vertical, 32)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 16))
                                
//                                Toggle("다른사람에게 공개", isOn: $isPublic)
//                                    .negguFont(.body2b)
//                                    .foregroundStyle(.labelAssistive)
//                                    .tint(.safe)
//                                    .padding(.horizontal, 28)
//                                    .padding(.vertical, 10)
//                                    .background(.white)
//                                    .clipShape(.rect(cornerRadius: 16))
                                
//                                HStack {
//                                    Button {
//                                        
//                                    } label: {
//                                        Image(.share)
//                                            .foregroundStyle(.white)
//                                            .frame(width: 56, height: 56)
//                                            .background {
//                                                RoundedRectangle(cornerRadius: 16)
//                                                    .fill(.black)
//                                            }
//                                    }
                                    
                                    Button {
                                        showNegguInviteAlert = true
                                    } label: {
                                        HStack(spacing: 10) {
                                            Image("neggu_star")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                            
                                            Text("네가 좀 꾸며줘!")
                                                .negguFont(.body1b)
                                        }
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.negguSecondary)
                                        }
                                    }
//                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 12)
                    }
                    .scrollIndicators(.hidden)
                    .background(.bgNormal)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showNegguInviteAlert {
                Color.bgDimmed
                    .ignoresSafeArea()
                
                NegguInviteAlert(showAlert: $showNegguInviteAlert)
            }
        }
        .sheet(isPresented: $showDateSheet) {
            LookBookDateSheet(selectedDate: $selectedDate)
                .presentationCornerRadius(20)
        }
        .negguAlert(.delete(.lookBook), showAlert: $showDeleteAlert) {
            viewModel.send(action: .onTapDelete(
                id: lookBookID,
                completion: {
                    lookBookViewModel.send(action: .refresh)
                    showDeleteAlert = false
                    coordinator.pop()
                }
            ))
        }
    }
}
