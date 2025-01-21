//
//  SignUpView.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var authCoordinator: AuthCoordinator
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @State private var fieldState: InputFieldState = .empty
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                Capsule()
                    .fill(.black.opacity(0.1))
                    .overlay(alignment: .topLeading) {
                        Capsule()
                            .fill(.orange40)
                            .frame(width: CGFloat(viewModel.step) * proxy.size.width / 4, height: 8)
                    }
            }
            .frame(width: 204, height: 8)
            .animation(.smooth, value: viewModel.step)
            
            Text("STEP \(viewModel.step)/4")
                .negguFont(.caption)
                .foregroundStyle(.labelAssistive)
                .padding(.top, 8)
            
            GeometryReader { proxy in
                ZStack {
                    SignUpNicknameView(fieldState: $fieldState)
                        .offset(y: viewModel.step == 1 ? 0 : viewModel.step > 1 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 1 ? 1 : 0)
                    
                    SignUpAgeView()
                        .offset(y: viewModel.step == 2 ? 0 : viewModel.step > 2 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 2 ? 1 : 0)
                    
                    SignUpGenderView()
                        .frame(height: proxy.size.height)
                        .offset(y: viewModel.step == 3 ? 0 : viewModel.step > 3 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 3 ? 1 : 0)
                    
                    SignUpMoodView()
                        .frame(height: proxy.size.height)
                        .offset(y: viewModel.step == 4 ? 0 : proxy.size.height)
                        .opacity(viewModel.step == 4 ? 1 : 0)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .animation(.smooth(duration: 0.5), value: viewModel.step)
                .overlay(alignment: .bottom) {
                    VStack {
                        Button {
                            switch viewModel.step {
                            case 1:
                                if viewModel.nickname.isValidNickname() {
                                    viewModel.checkNickname()
                                } else {
                                    fieldState = .error(message: "영소문자, 한글, 숫자 포함 7자까지 가능해요")
                                    viewModel.canNextStep = false
                                }
                            case 2..<4:
                                viewModel.step += 1
                            default:
                                viewModel.register { isSuccessed in
                                    if isSuccessed {
                                        authCoordinator.push(.complete)
                                    } else {
                                        print("회원가입에 실패했습니다.")
                                    }
                                }
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.canNextStep ? .negguSecondary : .labelInactive)
                                .frame(height: 56)
                                .overlay {
                                    Text("다음으로")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.white)
                                }
                        }
                        .disabled(!viewModel.canNextStep)
                        
                        if viewModel.step > 1 {
                            HStack {
                                Button {
                                    if viewModel.step < 1 { return }
                                    viewModel.step -= 1
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
                                
                                Spacer()
                            }
                            .frame(height: 24)
                        }
                    }
                    .padding(.bottom, 24)
                    .contentShape(.rect)
                }
            }
            .onChange(of: viewModel.step) { oldValue, newValue in
                if oldValue < newValue {
                    if newValue == 2 {
                        viewModel.canNextStep = true
                    } else {
                        viewModel.canNextStep = false
                    }
                } else {
                    switch viewModel.step {
                    case 1:
                        viewModel.age = 19
                    case 2:
                        viewModel.gender = .UNKNOWN
                    case 3:
                        viewModel.moodList.removeAll()
                    default: return
                    }
                    
                    viewModel.canNextStep = true
                }
            }
        }
        .padding(.horizontal, 20)
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

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
