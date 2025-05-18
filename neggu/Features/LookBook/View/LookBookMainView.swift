//
//  LookBookMainView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI
import Combine

struct LookBookMainView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @State private var showNegguList: Bool = false
    @State private var showDeleteList: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                Menu {
                    Button("환경 설정") {
                        coordinator.push(.setting)
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
                            switch viewModel.output.profileState {
                            case .loaded(let profile):
                                UserProfileHeader(profile: profile)
                                
                                VStack {
                                    UserLookBookStateView(profile: profile, scrollProxy: scrollProxy)
                                    
                                    StyleAnalyzeButton {
                                        coordinator.push(.insight)
                                    }
                                }
                            case .initial:
                                ProgressView()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            switch viewModel.output.profileState {
                            case .loaded(let profile):
                                Text(profile.nickname + "의 룩북")
                                    .negguFont(.title2)
                                    .lineLimit(1)
                                    .id("LookBook")
                            case .initial:
                                Text("사용자의 룩북")
                                    .negguFont(.title2)
                                    .id("LookBook")
                            }
                                                        
                            LazyVGrid(
                                columns: [GridItem](repeating: GridItem(.flexible(), spacing: 16), count: 2),
                                spacing: 16
                            ) {
                                ForEach(viewModel.output.lookBookList) { lookBook in
                                    Button {
                                        coordinator.push(.lookbookDetail(lookBookID: lookBook.lookBookId))
                                    } label: {
                                        LookBookCell(lookBook: lookBook)
                                            .frame(height: 260)
                                    }
                                }
                                
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 56)
                                    .onAppear {
                                        viewModel.send(action: .fetchLookBookList)
                                    }
                            }
                        }
                    }
                    .padding(.top, 32)
                    .padding(.bottom, viewModel.output.lookBookList.count % 2 == 0 ? 24 : 80)
                }
                .scrollIndicators(.hidden)
            }
        }
        .padding(.horizontal, 20)
        .background(.bgNormal)
        .refreshable {
            viewModel.send(action: .refresh)
        }
        .sheet(isPresented: $showNegguList) {
            Text("내가 꾸며준 룩북")
                .presentationDetents([.fraction(0.8)])
        }
    }
}
