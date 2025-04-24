//
//  UserProfileHeader.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import SwiftUI

struct UserProfileHeader: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    let profile: UserProfileEntity
    
    var body: some View {
        if let mood = profile.mood.first {
            HStack(spacing: 4) {
                Image(.titleBadgeIcon)
                
                Text(mood.title + "에 관심이 많은")
                    .negguFont(.body2b)
            }
            .foregroundStyle(.labelNormal)
            .frame(height: 28)
            .padding(.horizontal, 8)
            .background {
                Image(.titleBadgeBg)
                    .resizable()
                    .clipShape(.rect(cornerRadius: 8))
            }
        }
        
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
            .clipShape(.circle)
//            .overlay(alignment: .bottomTrailing) {
//                Button {
//                    coordinator.sheet = .nicknameEdit(nickname: profile.nickname)
//                } label: {
//                    Circle()
//                        .fill(.negguSecondary)
//                        .frame(width: 24, height: 24)
//                        .overlay {
//                            Image(.edit)
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 12, height: 12)
//                                .foregroundStyle(.white)
//                        }
//                }
//                .offset(y: 8)
//            }
        }
        
        Text("옷장이 잘 채워지고 있어요!")
            .negguFont(.body2b)
            .foregroundStyle(.labelAssistive)
            .padding(.bottom, 20)
    }
}
