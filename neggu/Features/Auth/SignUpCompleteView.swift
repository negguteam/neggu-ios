//
//  SignUpCompleteView.swift
//  neggu
//
//  Created by 유지호 on 1/5/25.
//

import SwiftUI

struct SignUpCompleteView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(.gray10)
                .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading) {
                Text("모든 준비가 끝났어요")
                    .negguFont(.body1)
                    .foregroundStyle(.labelAssistive)
                
                Text("좋아하는 옷부터\n네꾸에 등록해볼까요?")
                    .negguFont(.title2)
                    .foregroundStyle(.labelNormal)
            }
            .padding(.horizontal, 48)
            .padding(.top, 60)
            
            Spacer()
            
            VStack(spacing: 24) {
                Button {
                    UserDefaultsKey.Auth.isLogined = true
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("내 옷 등록하기")
                                .negguFont(.body1b)
                                .foregroundStyle(.labelRNormal)
                        }
                }
                
                Button {
                    
                } label: {
                    Text("우선 둘러보고 싶어요!")
                        .negguFont(.body2)
                        .foregroundStyle(.labelAlt)
                        .underline()
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SignUpCompleteView()
}
