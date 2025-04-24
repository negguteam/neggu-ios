//
//  LoginView.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authCoordinator: AuthCoordinator
    @EnvironmentObject private var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 100) {
            Image(.appLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            
            VStack(spacing: 12) {
                Button {
                    authViewModel.requestKakaoLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.kakaoYello)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                Image(.kakaoLogo)
                                    .frame(width: 44, height: 44)
                                
                                Text("카카오 로그인")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelNormal)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        }
                }
                
                Button {
                    authViewModel.requestGoogleLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                Image(.googleLogo)
                                    .frame(width: 44, height: 44)
                                
                                Text("Google 계정으로 계속하기")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelNormal)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        }
                }
                
                Button {
                    authViewModel.requestAppleLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                Image(.appleLogo)
                                    .frame(width: 44, height: 44)
                                
                                Text("Apple 계정으로 계속하기")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelRNormal)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 48)
        .background(.bgRNormal)
        .onChange(of: authViewModel.needEditNickname) { _, newValue in
            if !newValue { return }
            authCoordinator.push(.signUp)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
