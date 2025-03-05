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
        
    @Published var step: Int = 1
    @Published var canNextStep: Bool = false
    @Published var nickname: String = ""
    @Published var isDuplicatedNickname: Bool?
    @Published var age: Int = 19
    @Published var gender: Gender = .UNKNOWN
    @Published var moodList: [Mood] = []
    
    init(authService: AuthService = DefaultAuthService()) {
        self.authService = authService
    }
    
    private func login(_ socialType: SocialType, idToken: String) {
        needEditNickname = false
        
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
        }.store(in: &cancelBag)
    }
    
    func checkNickname() {
        authService.checkNickname(nickname: nickname)
            .sink { event in
                switch event {
                case .finished:
                    print("AuthViewModel: \(event)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] entity in
                self?.isDuplicatedNickname = entity.isDuplicate
            }.store(in: &cancelBag)
    }
    
    func register(completion: @escaping (Bool) -> Void) {
        authService.register(userProfile: [
            "nickname": nickname,
            "age": age + 1,
            "gender": gender.id,
            "mood": moodList.map { $0.id },
            "fcmToken": UserDefaultsKey.User.fcmToken ?? ""
        ])
        .sink { event in
            switch event {
            case .finished:
                print("AuthViewModel: \(event)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { entity in
            guard let accessToken = entity.accessToken,
                  let accessTokenExpiresIn = entity.accessTokenExpiresIn,
                  let refreshToken = entity.refreshToken,
                  let refreshTokenExpiresIn = entity.refreshTokenExpiresIn
            else {
                print("회원가입 실패")
                completion(false)
                return
            }
            
            print("회원가입 완료")
            UserDefaultsKey.Auth.accessToken = accessToken
            UserDefaultsKey.Auth.accessTokenExpiresIn = Date.now.addingTimeInterval(Double(accessTokenExpiresIn))
            UserDefaultsKey.Auth.refreshToken = refreshToken
            UserDefaultsKey.Auth.refreshTokenExpiresIn = Date.now.addingTimeInterval(Double(refreshTokenExpiresIn))
            completion(true)
        }
        .store(in: &cancelBag)
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
