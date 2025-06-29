//
//  SignUpViewModel.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

import Core
import Networks

import Foundation
import Combine

public final class SignUpViewModel: NSObject, ObservableObject {
    
    @Published var step: Int = 1
    @Published var canNextStep: Bool = false
    @Published var nickname: String = ""
    @Published var isDuplicatedNickname: Bool?
    @Published var age: Int = 19
    @Published var gender: Core.Gender = .UNKNOWN
    @Published var moodList: [Mood] = []
    
    private let authService: any AuthService
    
    private var bag = Set<AnyCancellable>()
    
    public init(authService: any AuthService) {
        self.authService = authService
    }
    
    
    public func checkNickname() {
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
            }.store(in: &bag)
    }
    
    public func register(completion: @escaping (Bool) -> Void) {
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
        .store(in: &bag)
    }
    
}
