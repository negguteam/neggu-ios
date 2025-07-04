//
//  UserProfileHeader.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import NegguDS
import Networks

import SwiftUI

struct UserProfileHeader: View {
    let profile: UserProfileEntity
    
    var body: some View {
//        if let mood = profile.mood.first {
//            HStack(spacing: 4) {
//                NegguImage.Icon.titleBadgeIcon
//                
//                Text(mood.title + "에 관심이 많은")
//                    .negguFont(.body2b)
//            }
//            .foregroundStyle(.labelNormal)
//            .frame(height: 28)
//            .padding(.horizontal, 8)
//            .background {
//                NegguImage.Background.gnbBg
//                    .resizable()
//                    .clipShape(.rect(cornerRadius: 8))
//            }
//        }
        
        HStack(spacing: 16) {
            Text("\(profile.nickname)님\n안녕하세요!")
                .negguFont(.title2)
                .foregroundStyle(.labelNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                if let profileImage = profile.profileImage {
                    CachedAsyncImage(profileImage)
                }
            }
            .frame(width: 74, height: 74)
            .clipShape(.circle)
        }
        
        Text("옷장이 잘 채워지고 있어요!")
            .negguFont(.body2b)
            .foregroundStyle(.labelAssistive)
            .padding(.bottom, 20)
    }
}
