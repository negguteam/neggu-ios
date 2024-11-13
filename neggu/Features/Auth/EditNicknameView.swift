//
//  EditNicknameView.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

struct EditNicknameView: View {
    @StateObject private var viewModel: NicknameEditViewModel
    
    @State private var step: Int? = 1
    
    init(viewModel: NicknameEditViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Capsule()
                .fill(.black.opacity(0.1))
                .frame(width: 204, height: 8)
                .padding(.bottom, 21)
                .overlay(alignment: .topLeading) {
                    Capsule()
                        .fill(.orange40)
                        .frame(width: CGFloat(step ?? 1) * 68, height: 8)
                }
            
            Text("STEP 1/3")
                .negguFont(.caption)
                .foregroundStyle(.labelAssistive.opacity(0.4))
                .padding(.bottom, 84)
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    VStack {
                        Text("닉네임을 입력해주세요!")
                            .negguFont(.title4)
                            .foregroundStyle(.labelNormal)
                        
                        TextField("닉네임을 입력해주세요.", text: $viewModel.nickname)
                            .negguFont(.body1b)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(.lineNormal, lineWidth: 1)
                            }
                            .padding(.horizontal, 44)
                            .padding(.bottom)
                        
                        Text("한글 최대 7자, 영문 14자까지 가능해요")
                            .negguFont(.caption)
                            .foregroundStyle(.labelAssistive.opacity(0.4))
                            .padding(.bottom, 112)
                        
            //            Button("중복확인") {
            //                viewModel.requestCheckNickname()
            //            }
            //
            //            if !viewModel.isDuplicatedNickname {
            //                Button("닉네임 변경") {
            //                    viewModel.requestUpdateInfo()
            //                }
            //            }
                        
                        Text("나이를 알려주세요!")
                            .negguFont(.title4)
                            .foregroundStyle(.labelNormal)
                        
                        HStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(.lineNormal)
                                .frame(width: 100, height: 63)
                            
                            Text("살")
                                .negguFont(.title4)
                                .foregroundStyle(.labelNormal)
                        }
                    }
                    .containerRelativeFrame(.horizontal)
                    .id(1)
                    
                    VStack {
                        Text("qwer")
                            .foregroundStyle(.black)
                    }
                    .containerRelativeFrame(.horizontal)
                    .id(2)
                    
                    VStack {
                        Text("xyz")
                            .foregroundStyle(.black)
                    }
                    .containerRelativeFrame(.horizontal)
                    .id(3)
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(true)
            .scrollPosition(id: $step)
            
            Spacer()
            
            Button {
                guard let step, step > 0 && step < 3 else { return }
                self.step = step + 1
            } label: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.labelAssistive)
                    .frame(height: 48)
                    .overlay {
                        Text("다음으로")
                            .negguFont(.body1b)
                            .foregroundStyle(.white)
                    }
            }
            
            HStack {
                Button {
                    guard let step, step > 1 else { return }
                    self.step = step - 1
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "chevron.left")
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        
                        Text("이전으로")
                            .negguFont(.body2)
                    }
                    .foregroundStyle(.labelAlt)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
        .padding()
        .background(.white)
        .animation(.smooth, value: step)
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
