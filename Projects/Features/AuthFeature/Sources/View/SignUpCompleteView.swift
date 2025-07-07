//
//  SignUpCompleteView.swift
//  neggu
//
//  Created by 유지호 on 1/5/25.
//

import Core

import SwiftUI

struct SignUpCompleteView: View {
    @EnvironmentObject private var authCoordinator: AuthCoordinator
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("모든 준비가 끝났어요")
                        .negguFont(.body1)
                        .foregroundStyle(.labelRAssistive)
                    
                    Text("좋아하는 옷부터\n네꾸 옷장에\n등록해보세요")
                        .negguFont(.title1)
                        .foregroundStyle(.labelRNormal)
                }
                .padding(.horizontal, 28)
                .padding(.top, 54)
                
                Spacer()
                
                VStack(spacing: 24) {
                    Button {
                        UserDefaultsKey.Auth.isLogined = true
                        authCoordinator.popToRoot()
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
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .background {
                Capsule()
                    .fill(.negguSecondary)
                    .blur(radius: 100)
                    .offset(y: size.height * 0.9)
            }
        }
        .background(.black)
    }
}
