//
//  SignUpNicknameView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @Binding var fieldState: InputFieldState
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("닉네임을 입력해주세요!")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
            
            HStack {
                TextField("", text: $viewModel.nickname)
                    .focused($isFocused)
                    .negguFont(.body1b)
                    .foregroundStyle(.labelAlt)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitScope(!viewModel.canNextStep)
                    .onSubmit {
                        if viewModel.nickname.isValidNickname() {
                            viewModel.checkNickname()
                        } else {
                            fieldState = .error(message: "영소문자, 한글, 숫자 포함 7자까지 가능해요")
                            viewModel.canNextStep = false
                        }
                    }
                    .onChange(of: viewModel.nickname) { _, newValue in
                        fieldState = newValue.isEmpty ? .empty : .editing
                        viewModel.canNextStep = true
                    }
                
                Button {
                    viewModel.nickname.removeAll()
                } label: {
                    Image(systemName: "multiply")
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.labelAlt)
                }
                .opacity(fieldState == .empty ? 0 : 1)
                .disabled(fieldState == .empty)
            }
            .frame(height: 50)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(fieldState.lineColor)
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(.warningAlt)
                .frame(height: 32)
                .overlay {
                    HStack(spacing: 4) {
                        Image(systemName: "multiply")
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.warning)
                        
                        Text(fieldState.description)
                            .negguFont(.caption)
                            .foregroundStyle(.warning)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                }
                .opacity(fieldState.description.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 48)
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.white
                .onTapGesture {
                    isFocused = false
                }
        }
        .onAppear {
            if viewModel.step != 1 { return }
            isFocused = true
        }
        .onChange(of: viewModel.step) { oldValue, newValue in
            if oldValue != 1 && newValue != 1 { return }
            
            if newValue == 1 {
                Task {
                    try await Task.sleep(for: .seconds(0.7))
                    isFocused = true
                }
            } else {
                isFocused = false
            }
        }
        .onChange(of: viewModel.isDuplicatedNickname) { _, newValue in
            guard let isDuplicated = newValue else { return }
    
            if isDuplicated {
                fieldState = .error(message: "이미 사용중인 닉네임이에요")
                viewModel.canNextStep = false
            } else {
                viewModel.step += 1
            }
            
            viewModel.isDuplicatedNickname = nil
        }
    }
}
