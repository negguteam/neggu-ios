//
//  LoginView.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authCoordinator: AuthCoordinator
    @StateObject private var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
    }
    
    var body: some View {
        VStack {            
            Button("구글 로그인") {
                authViewModel.requestGoogleLogin()
            }
            
            Button("애플 로그인") {
                authViewModel.requestAppleLogin()
            }
            
            Button("카카오 로그인") {
                authViewModel.requestKakaoLogin()
            }
        }
        .padding()
        .onChange(of: authViewModel.needEditNickname) { oldValue, newValue in
            if newValue {
                authCoordinator.push(.editNickname)
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
