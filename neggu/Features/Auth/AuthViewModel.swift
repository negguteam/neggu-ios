//
//  AuthViewModel.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

import Foundation
import Combine
import GoogleSignIn
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import CryptoKit

final class AuthViewModel: NSObject, ObservableObject {
    
    private let authService: AuthService
    private var cancelBag = Set<AnyCancellable>()
    
    @Published private(set) var needEditNickname: Bool = false
    
    init(authService: AuthService = DefaultAuthService()) {
        self.authService = authService
    }
    
    private func login(_ socialType: SocialType, socialID: String) {
        needEditNickname = false
        
        authService.login(
            socialType: socialType,
            socialID: socialID,
            fcmToken: UserDefaultsManager.fcmToken ?? ""
        ).sink { event in
            switch event {
            case .finished:
                print("AuthViewModel: \(event)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] entity in
            UserDefaultsManager.accountToken = entity.accountToken
            
            if entity.nickname == nil {
                self?.needEditNickname = true
            } else {
                UserDefaultsManager.showTabFlow = true
            }
        }.store(in: &cancelBag)
    }
    
}


extension AuthViewModel {
    
    func requestGoogleLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController
        else {
            print("There is no root view controller!")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            guard let userID = result?.user.userID else { return }
            self?.login(.google, socialID: userID)
        }
    }
    
    func requestKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    UserApi.shared.me { [weak self] user, error in
                        if let error {
                            print(error.localizedDescription)
                        } else {
                            guard let userID = user?.id else { return }
                            self?.login(.kakao, socialID: "\(userID)")
                        }
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    UserApi.shared.me { [weak self] user, error in
                        if let error {
                            print(error.localizedDescription)
                        } else {
                            guard let userID = user?.id else { return }
                            self?.login(.kakao, socialID: "\(userID)")
                        }
                    }
                }
            }
        }
    }
    
}


extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        login(.apple, socialID: credential.user)
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
