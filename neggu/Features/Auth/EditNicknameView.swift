//
//  EditNicknameView.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

struct EditNicknameView: View {
    @StateObject private var viewModel: NicknameEditViewModel
    
    init(viewModel: NicknameEditViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            TextField("닉네임을 입력해주세요.", text: $viewModel.nickname)
            
            Button("중복확인") {
                viewModel.requestCheckNickname()
            }
            
            if !viewModel.isDuplicatedNickname {
                Button("닉네임 변경") {
                    viewModel.requestUpdateInfo()
                }
            }
        }
        .padding()
    }
}

#Preview {
    EditNicknameView(viewModel: NicknameEditViewModel())
}


import Combine

class NicknameEditViewModel: ObservableObject {
    
    private let authService: AuthService
    private var cancelBag = Set<AnyCancellable>()
    
    @Published var nickname: String = ""
    @Published private(set) var isDuplicatedNickname: Bool = true
    
    init(authService: AuthService = DefaultAuthService()) {
        self.authService = authService
        
        $nickname.sink { [weak self] nickname in
            self?.isDuplicatedNickname = true
        }.store(in: &cancelBag)
    }
    
    func requestCheckNickname() {
        authService.checkNickname(nickname: nickname)
            .sink { event in
                switch event {
                case .finished:
                    print("AuthViewModel: \(event)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] entity in
                self?.isDuplicatedNickname = entity.isDuplicated
            }.store(in: &cancelBag)

    }
    
    func requestUpdateInfo() {
        authService.updateInfo(nickname: nickname)
            .sink { event in
                switch event {
                case .finished:
                    print("AuthViewModel: \(event)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { entity in
                UserDefaultsManager.showTabFlow = true
            }.store(in: &cancelBag)
    }
    
}
