//
//  SettingView.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import Core
import NegguDS
import Networks

import BaseFeature

import SwiftUI
import Combine
import FirebaseMessaging

struct SettingView: View {
    @EnvironmentObject private var coordinator: LookBookCoordinator
    
    @State private var showLogoutAlert: Bool = false
    @State private var showWithdrawAlert: Bool = false
    @State private var bag = Set<AnyCancellable>()
    
    private let service: UserService = DefaultUserService()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    coordinator.pop()
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
                        coordinator.push(.policy(.privacyPolicy))
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
                        coordinator.push(.policy(.termsOfUse))
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
        }
        .background(.bgNormal)
        .negguAlert(.logout, showAlert: $showLogoutAlert) {
            service.logout()
                .sink { event in
                    print("SettingView:", event)
                } receiveValue: { _ in
                    UserDefaultsKey.clearUserData()
                    UserDefaultsKey.Auth.isLogined = false
                    Messaging.messaging().deleteToken { _ in }
                }.store(in: &bag)
        }
        .negguAlert(.withdraw, showAlert: $showWithdrawAlert) {
            service.withdraw()
                .sink { event in
                    print("SettingView:", event)
                } receiveValue: { _ in
                    UserDefaultsKey.clearUserData()
                    UserDefaultsKey.Auth.isLogined = false
                    Messaging.messaging().deleteToken { _ in }
                }.store(in: &bag)
        }
    }
}

#Preview {
    SettingView()
}
