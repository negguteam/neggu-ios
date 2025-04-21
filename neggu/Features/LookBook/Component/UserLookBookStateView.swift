//
//  UserLookBookStateView.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import SwiftUI

struct UserLookBookStateView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    let profile: UserProfileEntity
    var scrollProxy: ScrollViewProxy
    
    var body: some View {
        HStack(spacing: 16) {
            switch viewModel.output.lookBookState {
            case .available(let lookBook):
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .overlay {
                        CachedAsyncImage(lookBook.imageUrl)
                            .overlay(alignment: .bottom) {
                                Text(lookBookDateString)
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
                    .onTapGesture {
                        coordinator.push(.lookbookDetail(lookBookID: lookBook.id))
                    }
            default:
                Button {
                    switch viewModel.output.lookBookState {
                    case .needLookBook:
                        coordinator.fullScreenCover = .lookbookRegister()
                    default:
                        coordinator.isGnbOpened = true
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
                    coordinator.activeTab = .closet
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
//                    showNegguList = true
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
    }
    
    private var lookBookStateString: String {
        switch viewModel.output.lookBookState {
        case .needLookBook: "룩북을\n등록해주세요!"
        default: "의상을 먼저\n등록해주세요!"
        }
    }
    
    private var lookBookDateString: String {
        switch viewModel.output.lookBookState {
        case .available(let lookBook):
            if let targetDate = lookBook.decorator?.targetDate,
               let date = targetDate.toISOFormatDate() {
                date.generateLookBookDate().0 + " 입을 룩북"
            } else {
                "입을 룩북"
            }
        default: ""
        }
    }
}
