//
//  SignUpNicknameView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import Core
import NegguDS

import SwiftUI

struct SignUpNicknameView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    
    @State private var fieldState: InputFieldState = .empty
    
    @FocusState private var isFocused: Bool
    
    init(viewModel: SignUpViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("닉네임을 입력해주세요!")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
                .padding(.bottom, 12)
            
            HStack {
                TextField(
                    "",
                    text: Binding(
                        get: { viewModel.nickname },
                        set: { viewModel.nicknameDidEdit.send($0) }
                    )
                )
                .focused($isFocused)
                .negguFont(.body1b)
                .foregroundStyle(.labelAlt)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                Button {
                    viewModel.nicknameDidEdit.send("")
                    isFocused.toggle()
                } label: {
                    NegguImage.Icon.smallX
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
                    .strokeBorder(fieldState == .empty || fieldState == .editing ? .lineNormal : .systemWarning)
            }
            
            HStack(spacing: 4) {
                NegguImage.Icon.smallX
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.systemWarning)
                
                Text(fieldState.description)
                    .negguFont(.body3b)
                    .foregroundStyle(.systemWarning)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.systemWarningAlt)
            )
            .padding(.horizontal, -24)
            .opacity(fieldState.description.isEmpty ? 0 : 1)
        }
        .padding(.horizontal, 48)
        .padding(.bottom, 80)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.bgNormal
                .onTapGesture {
                    isFocused = false
                }
        }
        .onChange(of: viewModel.step, initial: true) { oldValue, newValue in
            if oldValue != 1 && newValue != 1 { return }
            
            if newValue == 1 {
                Task {
                    try await Task.sleep(for: .seconds(0.5))
                    isFocused = true
                }
            } else {
                isFocused = false
            }
        }
        .onChange(of: viewModel.nicknameFieldState) { _, newValue in
            fieldState = newValue
        }
    }
}
