//
//  LookBookView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI
import Combine

struct LookBookView: View {
    enum ProfileState {
        case available(profile: UserProfileEntity)
        case unavailable
    }
    
    enum LookBookState {
        case available
        case none
        case needClothes
    }
    
    @EnvironmentObject private var lookbookCoordinator: MainCoordinator
    
    @State private var profileState: ProfileState = .unavailable
    
    @State private var lookbookState: LookBookState = .available
    @State private var lookBookList: [LookBookEntity] = []
    
    @State private var showNegguList: Bool = false
    @State private var showDeleteList: Bool = false
    
    let userService: UserService = DefaultUserService()
    let lookBookService: LookBookService = DefaultLookBookService()
    
    @State private var bag = Set<AnyCancellable>()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                Menu {
                    Button("환경 설정") {
                        lookbookCoordinator.push(.setting)
                    }
                    
                    Button("룩북 삭제하기", role: .destructive) {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .bold()
                        .foregroundStyle(.labelNormal)
                        .frame(width: 44, height: 44)
                }
            }
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 64) {
                        VStack(alignment: .leading, spacing: 16) {
                            switch profileState {
                            case .available(let profile):
                                Image("title_badge")
                                    .frame(height: 28)
                                
                                HStack(spacing: 16) {
                                    Text("\(profile.nickname)님\n안녕하세요!")
                                        .negguFont(.title2)
                                        .foregroundStyle(.labelNormal)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Circle()
                                        .frame(width: 74, height: 74)
                                        .overlay(alignment: .bottomTrailing) {
                                            Button {
                                                
                                            } label: {
                                                Circle()
                                                    .fill(.negguSecondary)
                                                    .frame(width: 24, height: 24)
                                                    .overlay {
                                                        Image(systemName: "pencil")
                                                            .foregroundStyle(.white)
                                                    }
                                            }
                                            .offset(y: 8)
                                        }
                                }
                                
                                Text("옷장이 잘 채워지고 있어요!")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelAssistive)
                                
                                VStack {
                                    HStack(spacing: 16) {
                                        switch lookbookState {
                                        case .available:
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.clear)
                                                .overlay {
                                                    Image(.dummyLookbook)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .overlay(alignment: .bottom) {
                                                            Text("내일 입을 룩북")
                                                                .negguFont(.body3b)
                                                                .foregroundStyle(.labelRNormal)
                                                                .padding(.horizontal)
                                                                .background {
                                                                    RoundedRectangle(cornerRadius: 16)
                                                                        .fill(.black.opacity(0.4))
                                                                        .frame(height: 30)
                                                                }
                                                                .padding(.bottom, 12)
                                                        }
                                                }
                                        default:
                                            Button {
                                                if lookbookState == .none {
                                                    lookbookCoordinator.fullScreenCover = .lookbookEdit()
                                                } else {
                                                    lookbookCoordinator.showTabbarList = true
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
                                                        Text(lookbookState == .none ? "룩북을\n등록해주세요!" : "의상을 먼저\n등록해주세요!")
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
                                                        
                                                        Image(systemName: "chevron.right")
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
                                                    
                                                    Image(systemName: "chevron.right")
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
                                        // MARK: 의상 없으면 의상 등록, 룩북 없으면 룩북 등록, 룩북 있으면 입을 날짜 최신인 룩북 표시
                                        userService.profile()
                                            .sink { event in
                                                print("UserProfile:", event)
                                            } receiveValue: { profile in
                                                profileState = .available(profile: profile)
                                                
                                                if profile.clothes.isEmpty {
                                                    lookbookState = .needClothes
                                                } else if profile.lookBooks.isEmpty {
                                                    lookbookState = .none
                                                } else {
                                                    lookbookState = .available
                                                }
                                            }.store(in: &bag)
                                    }
                            }
                            
                        }
                        
                        VStack(alignment: .leading) {
                            Text("홍길동의 룩북")
                                .negguFont(.title2)
                                .id("LookBook")
                            
                            HStack {
                                FilterButton(title: "분위기") {
                                    
                                }
                                
                                FilterButton(title: "최신순") {
                                    
                                }
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
                                    lookbookCoordinator.push(.lookbookDetail(lookBookID: lookBook.lookBookId))
                                } label: {
                                    LookBookCell(dateString: dateString, dateColor: dateColor, lookBook: lookBook, isNeggu: Bool.random())
                                }
                            }
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 56)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 20)
        .background(.gray5)
    }
}

#Preview {
//    NavigationStack {
        LookBookView()
//    }
    .environmentObject(MainCoordinator())
}
