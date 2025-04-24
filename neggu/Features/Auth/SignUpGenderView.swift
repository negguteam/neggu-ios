//
//  SignUpGenderView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpGenderView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("성별을 알려주세요")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
            
            Text("맞춤 경험을 제공해드리기 위해\n성별 정보가 필요해요")
                .negguFont(.body3)
                .foregroundStyle(.labelAssistive)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
            
            HStack(spacing: 16) {
                ForEach(Gender.allCasesArray) { gender in
                    Button {
                        viewModel.gender = (viewModel.gender == gender) ? .UNKNOWN : gender
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.gender == gender ? .negguSecondaryAlt : .white)
                            .strokeBorder(viewModel.gender == gender ? .negguSecondary : .labelAlt)
                            .frame(width: 80, height: 48)
                            .overlay {
                                Text(gender.title)
                                    .negguFont(.body1b)
                                    .foregroundStyle(viewModel.gender == gender ? .negguSecondary : .labelAlt)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 128)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.gender) { _, newValue in
            if viewModel.step != 3 { return }
            viewModel.canNextStep = newValue != .UNKNOWN
        }
    }
}
