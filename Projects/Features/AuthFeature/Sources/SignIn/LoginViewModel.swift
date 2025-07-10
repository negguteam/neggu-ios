//
//  LoginViewModel.swift
//  AuthFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Domain

import AuthFeatureInterface

import Foundation
import Combine
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import CryptoKit
import FirebaseMessaging

final class LoginViewModel: NSObject, ObservableObject {
    
    @Published private(set) var isSignUpFlow: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    private let router: any AuthRoutable
    private let authUsecase: any AuthUsecase
    
    init(
        router: any AuthRoutable,
        authUsecase: any AuthUsecase
    ) {
        self.router = router
        self.authUsecase = authUsecase
        super.init()
        
        bind()
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    private func bind() {
        authUsecase.isSignUpFlow
            .filter { $0 }
            .withUnretained(self)
            .sink { owner, _ in
                owner.router.routeToSignUp()
            }.store(in: &bag)
    }
    
    private func login(_ socialType: SocialType, idToken: String) {
        isSignUpFlow = false
        
        if UserDefaultsKey.User.fcmToken == nil {
            Messaging.messaging().token { token, error in
                guard let token else { return }
                UserDefaultsKey.User.fcmToken = token
            }
        }
        
        authUsecase.login(socialType, idToken: idToken)
    }
    
}


extension LoginViewModel {
    
    func requestGoogleLogin() {
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
    
    func requestKakaoLogin() {
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
    
    func requestAppleLogin() {
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
        
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityToken = credential.identityToken else { return }
        let idToken = String(decoding: identityToken, as: UTF8.self)
        login(.apple, idToken: idToken)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        print(error.localizedDescription)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
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
