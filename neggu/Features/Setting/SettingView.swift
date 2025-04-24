//
//  SettingView.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import SwiftUI
import Combine

struct SettingView: View {
    @EnvironmentObject private var coodinator: MainCoordinator
    
    @State private var allowNotification: Bool = false
    @State private var showAlert: Bool = false
    @State private var bag = Set<AnyCancellable>()
    
    let service: UserService = DefaultUserService()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    coodinator.pop()
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
                        
                    } label: {
                        HStack {
                            Text("오픈소스")
                            
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
                        
                    } label: {
                        HStack {
                            Text("개인정보 처리방침")
                            
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
                        service.logout()
                            .sink { event in
                                print("SettingView:", event)
                            } receiveValue: { _ in
                                UserDefaultsKey.clearUserData()
//                                UserDefaultsKey.clearPushToken()
                                UserDefaultsKey.Auth.isLogined = false
                            }.store(in: &bag)
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
                        showAlert = true
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
        .negguAlert(.withdraw, showAlert: $showAlert) {
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
