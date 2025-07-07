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
            
            Text("옷장이 잘 채워지고 있어요!")
                .negguFont(.body2b)
                .foregroundStyle(.labelInactive)
        }
        .padding(.horizontal)
        .padding(.vertical, 24)
        .background(.black)
        .clipShape(.rect(cornerRadius: 16))
    }
}
