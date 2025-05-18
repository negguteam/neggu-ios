//
//  SettingView.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import SwiftUI
import Combine
import FirebaseMessaging

struct SettingView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    
    @State private var allowNotification: Bool = false
    @State private var showLogoutAlert: Bool = false
    @State private var showWithdrawAlert: Bool = false
    @State private var bag = Set<AnyCancellable>()
    
    let service: UserService = DefaultUserService()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
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
            .foregroundStyle(.labelNormal)
            
            ScrollView {
                VStack(spacing: 0) {
                    Toggle("알림 수신", isOn: $allowNotification)
                        .tint(.safe)
                        .frame(height: 52)
                    
                    Rectangle()
                        .fill(.lineAlt)
                        .frame(height: 1)
                    
                    Button {
                        coordinator.push(.policyView(.privacyPolicy))
                    } label: {
                        HStack {
                            Text("개인정보 처리방침")
                            
                            Spacer()
                            
                            Image(.chevronRight)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelAlt)
                        }
                        .frame(height: 52)
                    }
                    
                    Rectangle()
                        .fill(.lineAlt)
                        .frame(height: 1)
                    
                    Button {
                        coordinator.push(.policyView(.termsOfUse))
                    } label: {
                        HStack {
                            Text("서비스 이용약관")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.labelAlt)
                        }
                        .frame(height: 52)
                    }
                    
                    Rectangle()
                        .fill(.lineAlt)
                        .frame(height: 1)
                    
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack {
                            Text("로그아웃")
                            
                            Spacer()
                        }
                    }
                    .frame(height: 52)
                    
                    Rectangle()
                        .fill(.lineAlt)
                        .frame(height: 1)
                    
                    Button {
                        showWithdrawAlert = true
                    } label: {
                        HStack {
                            Text("회원탈퇴")
                                .foregroundStyle(.warning)
                            
                            Spacer()
                        }
                    }
                    .frame(height: 52)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .negguFont(.body2b)
                .foregroundStyle(.labelNormal)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden, for: .navigationBar)
        .padding(.horizontal, 20)
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
