//
//  UserProfileHeader.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import NegguDS
import Domain

import SwiftUI

struct UserProfileHeader: View {
    let profile: UserProfileEntity
    
    var description: String {
        if profile.clothes.isEmpty {
            "아끼는 옷부터 등록해볼까요?"
        } else if profile.lookBooks.isEmpty {
            "첫 번째 코디를 만들어봐요!"
        } else {
            ["옷장이 잘 채워지고 있어요!", "멋진 취향인데요? 😎", "룩북이 점점 완성되어 가요 😃", "옷을 꽤나 입으시는군요?"].randomElement()!
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack(spacing: 16) {
                Text("\(profile.nickname)님\n안녕하세요")
                    .negguFont(.title2)
                    .foregroundStyle(.labelRNormal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NegguImage.Icon.bigNegguStar
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            
            Text(description)
                .negguFont(.body2b)
                .foregroundStyle(.labelInactive)
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
        .background(.black)
        .clipShape(.rect(cornerRadius: 16))
    }
}
