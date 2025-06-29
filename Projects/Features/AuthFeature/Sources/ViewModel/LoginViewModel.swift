//
//  LoginViewModel.swift
//  AuthFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Networks

import Foundation
import Combine
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import CryptoKit
import FirebaseMessaging

public final class LoginViewModel: NSObject, ObservableObject {
    
    @Published private(set) var needEditNickname: Bool = false
    
    private let authService: any AuthService
    
    private var bag = Set<AnyCancellable>()
    
    public init(authService: any AuthService) {
        self.authService = authService
    }
    
    
    private func login(_ socialType: SocialType, idToken: String) {
        needEditNickname = false
        
        if UserDefaultsKey.User.fcmToken == nil {
            Messaging.messaging().token { token, error in
                if let token {
                    UserDefaultsKey.User.fcmToken = token
                }
            }
        }
        
        authService.login(
            socialType: socialType,
            idToken: idToken
        ).sink { event in
            switch event {
            case .finished:
                print("AuthViewModel: \(event)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { entity in
            if let registerToken = entity.registerToken {
                print("회원가입 플로우 !", registerToken)
                self.needEditNickname = entity.status == "pending"
                UserDefaultsKey.Auth.registerToken = registerToken
            } else {
                print("로그인 완료")
                guard let accessToken = entity.accessToken,
                      let accessTokenExpiresIn = entity.accessTokenExpiresIn,
                      let refreshToken = entity.refreshToken,
                      let refreshTokenExpiresIn = entity.refreshTokenExpiresIn
                else { return }
                
                UserDefaultsKey.Auth.accessToken = accessToken
                UserDefaultsKey.Auth.accessTokenExpiresIn = Date.now.addingTimeInterval(Double(accessTokenExpiresIn))
                UserDefaultsKey.Auth.refreshToken = refreshToken
                UserDefaultsKey.Auth.refreshTokenExpiresIn = Date.now.addingTimeInterval(Double(refreshTokenExpiresIn))
                UserDefaultsKey.Auth.isLogined = true
            }
        }.store(in: &bag)
    }
    
}


extension LoginViewModel {
    
    public func requestGoogleLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("There is no root view controller!")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            guard let idToken = result?.user.idToken?.tokenString else { return }
            self.login(.google, idToken: idToken)
        }
    }
    
    public func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    guard let idToken = oauthToken?.idToken else { return }
                    self.login(.kakao, idToken: idToken)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    guard let idToken = oauthToken?.idToken else { return }
                    self.login(.kakao, idToken: idToken)
                }
            }
        }
    }
    
    public func requestAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}

extension LoginViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken else { return }
        let idToken = String(decoding: identityToken, as: UTF8.self)
        login(.apple, idToken: idToken)
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        print(error.localizedDescription)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            fatalError("There is no window!")
        }
        
        return window
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { charset[Int($0) % charset.count] }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        
        return hashString
    }
    
}
