//
//  UserLookBookStateView.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import NegguDS
import Networks

import SwiftUI

struct UserLookBookStateView: View {
    @EnvironmentObject private var coordinator: LookBookCoordinator
    
    let profile: UserProfileEntity
    let lookBookState: UserLookBookState
    var scrollProxy: ScrollViewProxy
    
    var body: some View {
        HStack(spacing: 12) {
            switch lookBookState {
            case .available(let lookBook):
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .aspectRatio(3/4, contentMode: .fit)
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
                    .clipped()
                    .onTapGesture {
                        coordinator.push(.lookBookDetail(id: lookBook.id))
                    }
            default:
                Button {
                    switch lookBookState {
                    case .needClothes:
                        Task {
                            coordinator.rootCoordinator?.gnbState = .clothes
                            coordinator.rootCoordinator?.isGnbOpened = true
                        }
                    default:
                        coordinator.presentFullScreen(.lookBookRegister)
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
                        .aspectRatio(3/4, contentMode: .fit)
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
                    coordinator.rootCoordinator?.activeTab = .closet
                } label: {
                    HStack(spacing: 24) {
                        VStack {
                            NegguImage.Icon.shirtFill
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelNormal)
                            
                            Text("의상")
                                .negguFont(.body2b)
                                .foregroundStyle(.labelNormal)
                        }
                        
                        Text("\(profile.clothes.count)벌")
                            .negguFont(.body1b)
                            .foregroundStyle(.labelAlt)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    HStack(spacing: 24) {
                        VStack {
                            NegguImage.Icon.closetFill
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelNormal)
                            
                            Text("룩북")
                                .negguFont(.body2b)
                                .foregroundStyle(.labelNormal)
                        }
                        
                        Text("\(profile.lookBooks.count)개")
                            .negguFont(.body1b)
                            .foregroundStyle(.labelAlt)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 28)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    }
                }
            }
        }
    }
    
    private var lookBookStateString: String {
        switch lookBookState {
        case .needClothes: "의상을 먼저\n등록해주세요!"
        default: "룩북을\n등록해주세요!"
        }
    }
    
    private var lookBookDateString: String {
        switch lookBookState {
        case .available:
            "입을 룩북"
        default: ""
        }
    }
}
