//
//  SignUpAgeView.swift
//  neggu
//
//  Created by 유지호 on 1/18/25.
//

import SwiftUI

struct SignUpAgeView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
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
        .padding(.bottom, 112)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.white
                .onTapGesture {
                    isFocused = false
                }
        }
        .onChange(of: viewModel.step) { oldValue, newValue in
            if oldValue == 1 && newValue == 2 {
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
