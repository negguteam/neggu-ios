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
        VStack {
            Image(.negguLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .padding(.top, 240)
                .padding(.bottom, 150)
            
            VStack(spacing: 12) {
                Button {
                    authViewModel.requestKakaoLogin()
                } label: {
                    HStack(spacing: 24) {
                        Rectangle()
                            .fill(.gray10)
                            .frame(width: 44, height: 44)
                        
                        Text("카카오 로그인")
                            .negguFont(.body2b)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.yellow)
                    }
                }
                
                Button {
                    authViewModel.requestGoogleLogin()
                } label: {
                    HStack(spacing: 24) {
                        Rectangle()
                            .fill(.gray10)
                            .frame(width: 44, height: 44)
                        
                        Text("Google 계정으로 계속하기")
                            .negguFont(.body2b)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                    }
                }
                
                Button {
                    authViewModel.requestAppleLogin()
                } label: {
                    HStack(spacing: 24) {
                        Rectangle()
                            .fill(.gray10)
                            .frame(width: 44, height: 44)
                        
                        Text("Apple 계정으로 계속하기")
                            .negguFont(.body2b)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .padding(.horizontal, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.black)
                    }
                }
            }
        }
        .padding(.horizontal, 48)
        .frame(maxHeight: .infinity)
        .background(.bgNormal)
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
