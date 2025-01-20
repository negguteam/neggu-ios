//
//  SignUpNicknameView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @State private var fieldState: InputFieldState = .empty
    
    @FocusState private var isFocused: Bool
    
    var validateNickname: Bool {
        viewModel.nickname.count >= 1 && viewModel.nickname.count <= 7
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("닉네임을 입력해주세요!")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
            
            HStack {
                TextField("", text: $viewModel.nickname)
                    .focused($isFocused)
                    .negguFont(.body1b)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        if validateNickname {
                            
                        } else {
                            fieldState = .error(message: "영소문자, 한글, 숫자 포함 7자까지 가능해요")
                        }
                    }
                    .onChange(of: viewModel.nickname) { _, newValue in
                        fieldState = newValue.isEmpty ? .empty : .editing
                        viewModel.canNextStep = validateNickname
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
        .onChange(of: viewModel.step) { oldValue, newValue in
            if oldValue != 1 { return }
            isFocused = false
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
        
        var lineColor: Color {
            switch self {
            case .error: .warning
            default: .lineNormal
            }
        }
    }
}
