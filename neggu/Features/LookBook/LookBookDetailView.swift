//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/13/24.
//

import SwiftUI
import Combine

struct LookBookDetailView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @State private var lookBookState: LookBookState = .loading
    @State private var selectedDate: Date?
    @State private var isPublic: Bool = false
    
    @State private var showCalendar: Bool = false
    @State private var showDeleteAlert: Bool = false
    
    let lookBookID: String
    
    var body: some View {
        VStack(spacing: 0) {
            switch lookBookState {
            case .loading:
                ProgressView()
                    .onAppear {
                        viewModel.getLookBookDetail(id: lookBookID) { lookBook in
                            lookBookState = .complete(lookBook: lookBook)
                        }
                    }
            case .complete(let lookBook):
                HStack {
                    Button {
                        coordinator.pop()
                    } label: {
                        Image(.chevronLeft)
                            .foregroundStyle(.labelNormal)
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Text("데이트룩")
                            .negguFont(.body1b)
                        
                        Button {
                            
                        } label: {
                            Image(.edit)
                                .frame(width: 24, height: 24)
                        }
                    }
                    .foregroundStyle(.labelNormal)
                    
                    Spacer()
                    
                    Menu {
                        Button("이미지로 저장하기") {
                            Task {
                                guard let lookBookImage = await lookBook.imageUrl.toImage() else { return }
                                UIImageWriteToSavedPhotosAlbum(lookBookImage, nil, nil, nil)
                            }
                        }
                        
                        Button("편집하기") {
                            let editingClothes = lookBook.lookBookClothes.map { $0.toLookBookItem() }
                            coordinator.fullScreenCover = .lookbookEdit(editingClothes: editingClothes)
                        }
                        
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
                                        AsyncImage(url: URL(string: decorator.imageUrl))
                                            .frame(width: 36, height: 36)
                                            .clipShape(.circle)
                                        
                                        HStack(spacing: 0) {
                                            Text(decorator.accountId)
                                                .foregroundStyle(.negguSecondary)
                                                .lineLimit(1)
                                            
                                            Text("님이 꾸며줬어요")
                                                .fixedSize()
                                        }
                                        .negguFont(.body2b)
                                    }
                                    .frame(height: 56)
                                    .padding(.horizontal, 14)
                                    .background(.bgNormal)
                                    .clipShape(.rect(cornerRadius: 16))
                                } else {
                                    Spacer()
                                }
                                
                                Button {
                                    coordinator.sheet = .lookbookDateSheet(date: $selectedDate)
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
                        .containerRelativeFrame(.horizontal)
                        .containerRelativeFrame(.vertical) { length, _ in length * 0.9 }
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
                                                .aspectRatio(0.8, contentMode: .fit)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 28)
                            .padding(.vertical, 32)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 16))
                            
                            Toggle("다른사람에게 공개", isOn: $isPublic)
                                .negguFont(.body2b)
                                .foregroundStyle(.labelAssistive)
                                .tint(.safe)
                                .padding(.horizontal, 28)
                                .padding(.vertical, 10)
                                .background(.white)
                                .clipShape(.rect(cornerRadius: 16))
                            
                            HStack {
                                Button {
                                    
                                } label: {
                                    Image(.share)
                                        .foregroundStyle(.white)
                                        .frame(width: 56, height: 56)
                                        .background {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.black)
                                        }
                                }
                                
                                Button {
                                    
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
                            }
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
        .toolbar(.hidden, for: .navigationBar)
        .negguAlert(
            showAlert: $showDeleteAlert,
            title: "룩북을 삭제할까요?",
            description: "삭제한 룩북은 복구되지 않습니다.",
            leftContent: "취소하기",
            rightContent: "삭제하기"
        ) {
            viewModel.deleteLookBook(id: lookBookID) {
                coordinator.pop()
            }
        }
    }
    
    enum LookBookState {
        case loading
        case complete(lookBook: LookBookEntity)
    }
}
