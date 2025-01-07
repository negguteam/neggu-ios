//
//  SignUpNicknameView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpNicknameView: View {
    enum Field: Hashable {
        case nickname
        case age
    }
    
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @FocusState private var focusedField: Field?
    
    var validateNickname: Bool {
        viewModel.nickname.count >= 1 && viewModel.nickname.count <= 7
    }
    
    var body: some View {
        VStack {
            Group {
                Text("닉네임을 입력해주세요!")
                    .negguFont(.title4)
                    .foregroundStyle(.labelNormal)
                    .padding(.top, 40)
                
                HStack {
                    TextField("", text: $viewModel.nickname)
                        .focused($focusedField, equals: .nickname)
                        .negguFont(.body1b)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onSubmit {
                            if validateNickname {
                                viewModel.showAgeField = true
                            } else {
                                print("잘못된 닉네임입니다.")
                            }
                        }
                    
                    Button {
                        viewModel.nickname.removeAll()
                    } label: {
                        Image(systemName: "multiply")
                            .foregroundStyle(validateNickname ? .lineNormal : .warning)
                    }
                    .opacity(viewModel.nickname.count > 0 ? 1 : 0)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(validateNickname ? .lineNormal : .warning)
                }
                .padding(.horizontal, 44)
                .padding(.bottom)
                
                if !validateNickname {
                    Text("한글 최대 7자, 영문 14자까지 가능해요")
                        .negguFont(.caption)
                        .foregroundStyle(validateNickname ? .labelAssistive.opacity(0.4) : .warning)
                }
            }
            .offset(y: viewModel.showAgeField ? -36 : 0)
            .opacity(viewModel.showAgeField ? 0.3 : 1)
            .disabled(viewModel.showAgeField)
            
            Group {
                Text("나이를 알려주세요!")
                    .negguFont(.title4)
                    .foregroundStyle(.labelNormal)
                    .padding(.top, 40)
                
                HStack(spacing: 12) {
                    TextField("", text: $viewModel.age)
                        .focused($focusedField, equals: .age)
                        .negguFont(.title4)
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.numberPad)
                        .frame(width: 100, height: 63)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(.lineNormal)
                        }
                        .onChange(of: viewModel.age) { oldValue, newValue in
                            if oldValue.count <= newValue.count && newValue.count >= 2 {
                                viewModel.canNextStep = validateNickname && viewModel.age.count >= 2
                                focusedField = nil
                            }
                        }
                    
                    Text("살")
                        .negguFont(.title4)
                        .foregroundStyle(.labelNormal)
                }
            }
            .opacity(viewModel.showAgeField ? 1 : 0)
            .disabled(!viewModel.showAgeField)
            
            Spacer()
        }
        .animation(.smooth, value: viewModel.showAgeField)
        .background {
            Color.white
                .onTapGesture {
                    viewModel.canNextStep = validateNickname && viewModel.age.count >= 2
                    focusedField = nil
                }
        }
        .onAppear {
            viewModel.canNextStep = !viewModel.age.isEmpty
            
            viewModel.nextAction = {
                viewModel.step += 1
            }
            
            viewModel.beforeAction = {
                if viewModel.step > 1 {
                    viewModel.step -= 1
                } else {
                    viewModel.canNextStep = false
                    viewModel.showAgeField = false
                    viewModel.age.removeAll()
                }
            }
        }
        .onChange(of: viewModel.showAgeField) { _, newValue in
            if !newValue {
                focusedField = .nickname
            } else {
                focusedField = .age
            }
        }
    }
}
