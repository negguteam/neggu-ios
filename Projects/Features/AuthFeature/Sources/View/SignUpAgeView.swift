//
//  SignUpAgeView.swift
//  neggu
//
//  Created by 유지호 on 1/18/25.
//

import NegguDS

import SwiftUI

public struct SignUpAgeView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    
    @FocusState private var isFocused: Bool
    
    public init(viewModel: SignUpViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            Text("나이를 알려주세요!")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
            
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.lineNormal)
                    .frame(width: 80, height: 50)
                    .overlay {
                        PickerField(
                            "",
                            data: Array(1...99).map { "\($0)" },
                            selectionIndex: $viewModel.age
                        )
                        .focused($isFocused)
                    }
                
                Text("살")
                    .negguFont(.title4)
                    .foregroundStyle(.labelNormal)
            }
        }
        .padding(.bottom, 128)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.bgNormal
                .onTapGesture {
                    isFocused = false
                }
        }
        .onChange(of: viewModel.step) { oldValue, newValue in
            if oldValue != 2 && newValue != 2 { return }
            
            if newValue == 2 {
                Task {
                    try await Task.sleep(for: .seconds(0.7))
                    isFocused = true
                }
            } else {
                isFocused = false
            }
        }
    }
}
