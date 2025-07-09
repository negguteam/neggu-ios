//
//  SettingView.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import Core
import NegguDS
import Domain

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

struct SettingView: View {
    @StateObject private var router: SettingRouter
    
    @State private var showLogoutAlert: Bool = false
    @State private var showWithdrawAlert: Bool = false
    
    private let usecase: any UserUsecase
    
    init(
        router: SettingRouter,
        usecase: any UserUsecase
    ) {
        self._router = StateObject(wrappedValue: router)
        self.usecase = usecase
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    router.pop()
                } label: {
                    NegguImage.Icon.chevronLeft
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
                
                Text("환경설정")
                    .negguFont(.body1b)
                
                Spacer()
                
                Rectangle()
                    .fill(.clear)
                    .frame(width: 44, height: 44)
            }
            .frame(height: 44)
            .padding(.horizontal, 20)
            .foregroundStyle(.labelNormal)
            
            List {
                Section {
                    Button {
                        router.routeToPolicy(.privacyPolicy)
                    } label: {
                        HStack {
                            Text("개인정보 처리방침")
                            
                            Spacer()
                            
                            NegguImage.Icon.chevronRight
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelAlt)
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    Button {
                        router.routeToPolicy(.termsOfUse)
                    } label: {
                        HStack {
                            Text("서비스 이용약관")
                            
                            Spacer()
                            
                            NegguImage.Icon.chevronRight
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelAlt)
                        }
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("약관")
                        .negguFont(.body3b)
                }
                
                Section {
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Text("로그아웃")
                            
                            Spacer()
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    Button {
                        showWithdrawAlert = true
                    } label: {
                        HStack {
                            Text("탈퇴하기")
                                .foregroundStyle(.systemWarning)
                            
                            Spacer()
                        }
                    }
                    .listRowSeparator(.hidden)
                    
                    HStack {
                        Text("버전 정보")
                        
                        Spacer()
                        
                        Text(Util.appVersion)
                            .foregroundStyle(.labelAlt)
                    }
                    .listRowSeparator(.hidden)
                } header: {
                    Text("기타")
                        .negguFont(.body3b)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .negguFont(.body2b)
            .foregroundStyle(.labelNormal)
            
//            BannerViewContainer()
//                .frame(height: 50)
        }
        .background(.bgNormal)
        .negguAlert(.logout, showAlert: $showLogoutAlert) {
            usecase.logout()
        }
        .negguAlert(.withdraw, showAlert: $showWithdrawAlert) {
            usecase.withdraw()
        }
    }
}
