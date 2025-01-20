//
//  SignUpNicknameView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @State private var nicknameString: String = ""
    @State private var fieldState: InputFieldState = .empty
    
    @FocusState private var isFocused: Bool
    
    var validateNickname: Bool {
        nicknameString.count >= 1 && nicknameString.count <= 7
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("닉네임을 입력해주세요!")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
            
            HStack {
                TextField("", text: $nicknameString)
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
                
                Button {
                    nicknameString.removeAll()
                } label: {
                    Image(systemName: "multiply")
                        .foregroundStyle(.labelAlt)
                }
                .opacity(fieldState != .empty ? 1 : 0)
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
            if oldValue == 1 && newValue == 2 {
                viewModel.nickname = nicknameString
            }
            
            isFocused = false
        }
        .onChange(of: validateNickname) { _, newValue in
            viewModel.canNextStep = newValue
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
