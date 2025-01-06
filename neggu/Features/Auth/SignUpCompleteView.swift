//
//  SignUpCompleteView.swift
//  neggu
//
//  Created by 유지호 on 1/5/25.
//

import SwiftUI

struct SignUpCompleteView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 50)
                .fill(.gray10)
                .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading) {
                Text("모든 준비가 끝났어요")
                    .negguFont(.body3)
                    .foregroundStyle(.labelAlt)
                
                Text("좋아하는 옷부터\n네꾸에 등록해볼까요?")
                    .negguFont(.title2)
                    .foregroundStyle(.labelNormal)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 60)
            
            Spacer()
            
            VStack {
                Button {
                    UserDefaultsKey.Auth.isLogined = true
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.negguSecondary)
                        .frame(height: 48)
                        .overlay {
                            Text("내 옷을 네꾸에 등록하기")
                                .negguFont(.body1b)
                                .foregroundStyle(.white)
                        }
                }
                .padding(.horizontal, 20)
                
                Button {
                    
                } label: {
                    Text("먼저 둘러보고 싶어요!")
                        .negguFont(.body2)
                        .foregroundStyle(.labelAlt)
                        .underline()
                        .frame(height: 11)
                }
            }
        }
        .padding(.bottom, 32)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SignUpCompleteView()
}
