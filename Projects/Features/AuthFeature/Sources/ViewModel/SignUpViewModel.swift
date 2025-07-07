//
//  SignUpViewModel.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

import Core
import Domain

import Foundation
import Combine

public final class SignUpViewModel: NSObject, ObservableObject {
    
    // MARK: Input
    let nicknameDidEdit = PassthroughSubject<String, Never>()
    let ageDidSelect = PassthroughSubject<Int, Never>()
    let genderDidSelect = PassthroughSubject<Core.Gender, Never>()
    let moodDidSelect = PassthroughSubject<[Mood], Never>()
    let nextButtonDidTap = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    @Published private(set) var nickname: String = ""
    @Published private(set) var age: Int = 19
    @Published private(set) var gender: Core.Gender = .UNKNOWN
    @Published private(set) var mood: [Mood] = []
    @Published private(set) var step: Int = 1
    @Published private(set) var nicknameFieldState: InputFieldState = .empty
    @Published private(set) var isRegistered: Bool = false
    
    private var bag = Set<AnyCancellable>()
    
    private let authUsecase: any AuthUsecase
    
    public init(authUsecase: any AuthUsecase) {
        self.authUsecase = authUsecase
        super.init()
        
        bind()
        print("\(self) init")
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    
    private func bind() {
        nicknameDidEdit
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, nickname in
                owner.nickname = nickname
                owner.nicknameFieldState = nickname.isEmpty ? .empty : .editing
            }.store(in: &bag)
        
        ageDidSelect
            .assign(to: \.age, on: self)
            .store(in: &bag)
        
        genderDidSelect
            .assign(to: \.gender, on: self)
            .store(in: &bag)
        
        moodDidSelect
            .assign(to: \.mood, on: self)
            .store(in: &bag)
        
        nextButtonDidTap
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                switch owner.step {
                case 1:
                    if owner.nickname.isValidNickname() {
                        owner.authUsecase.checkNickname(owner.nickname)
                    } else {
                        owner.nicknameFieldState = .error(message: "영소문자, 한글, 숫자 포함 7자까지 가능해요")
                    }
                case 2:
                    owner.step += 1
                case 3:
                    if owner.gender == .UNKNOWN { return }
                    owner.step += 1
                case 4:
                    if owner.mood.isEmpty { return }
                    owner.authUsecase.register(
                        nickname: owner.nickname,
                        age: owner.age,
                        gender: owner.gender,
                        moodList: owner.mood
                    )
                default: return
                }
            }.store(in: &bag)
        
        authUsecase.isDuplicatedNickname
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, isDuplicated in
                if isDuplicated {
                    owner.nicknameFieldState = .error(message: "이미 사용중인 닉네임이에요")
                } else {
                    owner.step += 1
                }
            }.store(in: &bag)
        
        authUsecase.isRegistered
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, isRegistered in
                owner.isRegistered = isRegistered
            }.store(in: &bag)
    }
    
    func tapBackButton() {
        if step < 1 { return }
        step -= 1
    }
    
    func reset() {
        nickname = ""
        age = 19
        gender = .UNKNOWN
        mood.removeAll()
        step = 1
        isRegistered = false
    }
        
}

enum InputFieldState: Equatable {
    case empty
    case editing
    case error(message: String)
    
    var description: String {
        switch self {
        case .error(let message): message
        default: ""
        }
    }
}
