//
//  UserLookBookStateView.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import NegguDS
import Domain

import SwiftUI

struct UserLookBookStateView: View {
    @EnvironmentObject private var coordinator: LookBookCoordinator
    
    let profile: UserProfileEntity
    let lookBookState: UserLookBookState
    
    var body: some View {
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
