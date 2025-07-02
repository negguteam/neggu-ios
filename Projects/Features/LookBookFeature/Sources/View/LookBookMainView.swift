//
//  LookBookMainView.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import NegguDS

import SwiftUI

struct LookBookMainView: View {
    @EnvironmentObject private var coordinator: LookBookCoordinator
    
    @StateObject private var viewModel: LookBookMainViewModel
    
    init(viewModel: LookBookMainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Spacer()
                
                NegguImage.Icon.setting
                    .foregroundStyle(.labelNormal)
                    .frame(width: 44)
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        if let profile = viewModel.userProfile {
                            VStack(alignment: .leading, spacing: 16) {
                                UserProfileHeader(profile: profile)
                                
                                UserLookBookStateView(
                                    profile: profile,
                                    lookBookState: viewModel.lookBookState,
                                    scrollProxy: scrollProxy
                                )
                            }
                            
                            Text(profile.nickname + "의 룩북")
                                .negguFont(.title2)
                                .lineLimit(1)
                                .id("LookBook")
                        } else {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                            
                            Text("나의 룩북")
                                .negguFont(.title2)
                                .id("LookBook")
                        }
                        
                        LazyVGrid(
                            columns: [GridItem](repeating: .init(.flexible(), spacing: 12), count: 2),
                            spacing: 12
                        ) {
                            ForEach(viewModel.lookBookList) { lookBook in
                                Button {
                                    coordinator.push(.detail(id: lookBook.id))
                                } label: {
                                    LookBookCell(lookBook: lookBook)
                                        .aspectRatio(3/4, contentMode: .fit)
                                }
                                .onAppear {
                                    guard let last = viewModel.lookBookList.last,
                                          lookBook.id == last.id
                                    else { return }
                                    
                                    viewModel.lookBookDidScroll.send(())
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    .padding(.bottom, 80)
                }
            }
        }
        .background(.bgNormal)
        .refreshable {
            viewModel.lookBookDidRefresh.send(())
        }
        .onAppear {
            viewModel.viewDidAppear.send(())
        }
    }
}
