//
//  LoginView.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import NegguDS

import SwiftUI
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 100) {
            NegguImage.Logo.appLogo
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 240)
            
            VStack(spacing: 12) {
                Button {
                    viewModel.requestKakaoLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(NegguDSAsset.Colors.kakaoYello.swiftUIColor)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                NegguImage.SocialIcon.kakao
                                    .frame(width: 44, height: 44)
                                
                                Text("Kakao 계정으로 로그인")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelNormal)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        }
                }
                
                Button {
                    viewModel.requestGoogleLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                NegguImage.SocialIcon.google
                                    .frame(width: 44, height: 44)
                                
                                Text("Google 계정으로 로그인")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelNormal)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 8)
                        }
                }
                
                Button {
                    viewModel.requestAppleLogin()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                        .strokeBorder(.white)
                        .frame(height: 56)
                        .overlay {
                            HStack(spacing: 0) {
                                NegguImage.SocialIcon.apple
                                    .frame(width: 44, height: 44)
                                
                                Text("Apple 계정으로 로그인")
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
        .onOpenURL { url in
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            } else {
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
