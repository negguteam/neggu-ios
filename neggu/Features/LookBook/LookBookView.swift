//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI
import Combine

struct LookBookView: View {
    @EnvironmentObject private var lookbookCoordinator: MainCoordinator
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @State private var showNegguList: Bool = false
    @State private var showDeleteList: Bool = false
    
    var lookBookStateString: String {
        viewModel.lookbookState == .none ? "룩북을\n등록해주세요!" : "의상을 먼저\n등록해주세요!"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                Menu {
                    Button("환경 설정") {
                        lookbookCoordinator.push(.setting)
                    }
                    
                    Button("룩북 삭제하기", role: .destructive) {
                        showDeleteList = true
                    }
                } label: {
                    Image(.hamburgerHorizontal)
                        .foregroundStyle(.labelNormal)
                        .frame(width: 44, height: 44)
                }
            }
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 64) {
                        VStack(alignment: .leading, spacing: 16) {
                            switch viewModel.profileState {
                            case .available(let profile):
                                Image("title_badge")
                                    .frame(height: 28)
                                
                                HStack(spacing: 16) {
                                    Text("\(profile.nickname)님\n안녕하세요!")
                                        .negguFont(.title2)
                                        .foregroundStyle(.labelNormal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Group {
                                        if let profileImage = profile.profileImage {
                                            CachedAsyncImage(profileImage)
                                        } else {
                                            Circle()
                                        }
                                    }
                                    .frame(width: 74, height: 74)
                                    .overlay(alignment: .bottomTrailing) {
                                        Button {
                                            
                                        } label: {
                                            Circle()
                                                .fill(.negguSecondary)
                                                .frame(width: 24, height: 24)
                                                .overlay {
                                                    Image(.edit)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 12, height: 12)
                                                        .foregroundStyle(.white)
                                                }
                                        }
                                        .offset(y: 8)
                                    }
                                }
                                
                                Text("옷장이 잘 채워지고 있어요!")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelAssistive)
                                    .padding(.bottom, 20)
                                
                                VStack {
                                    HStack(spacing: 16) {
                                        switch viewModel.lookbookState {
                                        case .available:
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(.white)
                                                .overlay {
                                                    Image(.dummyLookbook)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .overlay(alignment: .bottom) {
                                                            Text("내일 입을 룩북")
                                                                .negguFont(.body3b)
                                                                .foregroundStyle(.labelRNormal)
                                                                .frame(height: 30)
                                                                .padding(.horizontal)
                                                                .background {
                                                                    RoundedRectangle(cornerRadius: 16)
                                                                        .fill(.black.opacity(0.4))
                                                                }
                                                                .padding(.bottom, 12)
                                                        }
                                                }
                                        default:
                                            Button {
                                                if viewModel.lookbookState == .none {
                                                    lookbookCoordinator.fullScreenCover = .lookbookEdit()
                                                } else {
                                                    lookbookCoordinator.isGnbOpened = true
                                                }
                                            } label: {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(.bgInactive)
                                                    .strokeBorder(
                                                        .lineAlt,
                                                        style: StrokeStyle(
                                                            lineWidth: 2,
                                                            dash: [4, 4]
                                                        )
                                                    )
                                                    .overlay {
                                                        Text(lookBookStateString)
                                                            .negguFont(.title4)
                                                            .foregroundStyle(.labelInactive)
                                                            .multilineTextAlignment(.center)
                                                        
                                                        Circle()
                                                            .fill(.negguSecondary)
                                                            .frame(width: 24, height: 24)
                                                            .overlay {
                                                                Image(systemName: "plus")
                                                                    .bold()
                                                                    .foregroundStyle(.white)
                                                            }
                                                            .offset(y: 64)
                                                    }
                                            }
                                        }
                                        
                                        VStack {
                                            Button {
                                                lookbookCoordinator.activeTab = .closet
                                            } label: {
                                                HStack {
                                                    Image("shirt_fill")
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(.labelNormal)
                                                    
                                                    Text("의상")
                                                        .negguFont(.body2b)
                                                        .foregroundStyle(.labelNormal)
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(profile.clothes.count)벌")
                                                        .negguFont(.body1b)
                                                        .foregroundStyle(.labelAlt)
                                                }
                                                .padding(.horizontal, 24)
                                                .padding(.vertical, 28)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(.white)
                                                }
                                            }
                                            
                                            Button {
                                                withAnimation(.smooth) {
                                                    scrollProxy.scrollTo("LookBook", anchor: .top)
                                                }
                                            } label: {
                                                HStack {
                                                    Image("closet_fill")
                                                        .frame(width: 24, height: 24)
                                                        .foregroundStyle(.labelNormal)
                                                    
                                                    Text("룩북")
                                                        .negguFont(.body2b)
                                                        .foregroundStyle(.labelNormal)
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(profile.lookBooks.count)개")
                                                        .negguFont(.body1b)
                                                        .foregroundStyle(.labelAlt)
                                                }
                                                .padding(.horizontal, 24)
                                                .padding(.vertical, 28)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(.white)
                                                }
                                            }
                                            
                                            Button {
                                                showNegguList = true
                                            } label: {
                                                VStack {
                                                    HStack(spacing: 12) {
                                                        Image("neggu_star")
                                                            .frame(width: 24, height: 24)
                                                        
                                                        Text("0번 네꾸했어요!")
                                                            .negguFont(.body2b)
                                                            .foregroundStyle(.labelRNormal)
                                                    }
                                                    
                                                    HStack {
                                                        Text("내가 꾸며준 코디 보러가기")
                                                        
                                                        Image(.chevronRight)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 12, height: 12)
                                                    }
                                                    .negguFont(.caption)
                                                    .foregroundStyle(.labelRAssistive)
                                                }
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 18)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(.negguSecondary)
                                                }
                                            }
                                        }
                                    }
                                    
                                    Button {
                                        lookbookCoordinator.push(.insight)
                                    } label: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(.negguPrimary)
                                            .frame(height: 56)
                                            .overlay {
                                                HStack {
                                                    Image("neggu_star")
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text("내 취향분석 더 보기")
                                                        .negguFont(.body2b)
                                                    
                                                    Image(.chevronRight)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .foregroundStyle(.labelRAssistive)
                                                        .frame(width: 12, height: 12)
                                                }
                                                .foregroundStyle(.labelRNormal)
                                            }
                                            .overlay(alignment: .topTrailing) {
                                                Image("lookbook_favorite_top")
                                                
                                                Image("lookbook_favorite_bottom")
                                            }
                                    }
                                }
                            case .unavailable:
                                ProgressView()
                                    .onAppear {
                                        viewModel.fetchProfile()
                                    }
                            }
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            switch viewModel.profileState {
                            case .available(let profile):
                                Text(profile.nickname + "의 룩북")
                                    .negguFont(.title2)
                                    .lineLimit(1)
                                    .id("LookBook")
                            case .unavailable:
                                Text("사용자의 룩북")
                                    .negguFont(.title2)
                                    .id("LookBook")
                            }
                            
                            HStack {
                                FilterButton(title: "분위기") {
                                    
                                }
                                
                                FilterButton(title: "최신순") {
                                    
                                }
                            }
                            .negguFont(.body3b)
                            .foregroundStyle(.gray50)
                            
                            LazyVGrid(
                                columns: [GridItem](repeating: GridItem(.flexible(), spacing: 16), count: 2),
                                spacing: 16
                            ) {
                                ForEach(viewModel.lookBookList) { lookBook in
                                    Button {
                                        lookbookCoordinator.push(.lookbookDetail(lookBookID: lookBook.lookBookId))
                                    } label: {
                                        LookBookCell(lookBook: lookBook, targetDate: .now.addingTimeInterval(.random(in: 0...10) * 24 * 60 * 60))
                                            .frame(height: 260)
                                    }
                                }
                                
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 56)
                                    .onAppear {
                                        viewModel.getLookBookList()
                                    }
                            }
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, viewModel.lookBookList.count % 2 == 0 ? 24 : 80)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 20)
        .background(.bgNormal)
        .refreshable {
            viewModel.resetLookBookList()
        }
        .sheet(isPresented: $showNegguList) {
            Text("내가 꾸며준 룩북")
                .presentationDetents([.fraction(0.8)])
                .presentationCornerRadius(20)
        }
        .sheet(isPresented: $showDeleteList) {
            LookBookDeleteSheet()
                .presentationDetents([.fraction(0.8)])
                .presentationCornerRadius(20)
        }
    }
}

#Preview {
//    NavigationStack {
        LookBookView()
//    }
    .environmentObject(MainCoordinator())
}
