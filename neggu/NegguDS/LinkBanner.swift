//
//  LinkBanner.swift
//  neggu
//
//  Created by 유지호 on 1/14/25.
//

import SwiftUI

struct LinkBanner: View {
    @Binding var urlString: String
    
    let buttonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 24) {
                Text("갖고 있는 옷을\n한눈에 모아보세요!")
                    .negguFont(.title3)
                    .foregroundStyle(.labelRNormal)
                
                Text("링크를 입력해 옷장에 담고 코디해보세요!")
                    .negguFont(.body2)
                    .foregroundStyle(.labelRAlt)
            }
            .padding(.horizontal, 12)
            
            HStack(spacing: 16) {
                Image(.link)
                    .foregroundStyle(.labelAssistive)
                    .padding(.leading, 12)
                
                TextField(
                    "",
                    text: $urlString,
                    prompt: Text("무신사, 에이블리, ...").foregroundStyle(.labelInactive)
                )
                .negguFont(.body2)
                
                
                Button {
                    buttonAction()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.white)
                        }
                }
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .strokeBorder(.lineAlt)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(.negguSecondary)
        }
        .overlay(alignment: .topTrailing) {
            Image(.linkBannerTop)
            
            Image(.linkBannerBottom)
        }
    }
}
