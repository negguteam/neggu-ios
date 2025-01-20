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
        VStack {
            Text("성별을 알려주세요")
                .negguFont(.title4)
                .foregroundStyle(.labelNormal)
                .padding(.bottom)
            
            Text("맞춤 경험을 제공해드리기 위해\n홍길동님의 성별 정보가 필요해요")
                .negguFont(.body3)
                .foregroundStyle(.labelAssistive)
                .multilineTextAlignment(.center)
                .padding(.bottom, 60)
            
            HStack(spacing: 16) {
                ForEach(Gender.allCasesArray) { gender in
                    Button {
                        viewModel.gender = (viewModel.gender == gender) ? .UNKNOWN : gender
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.lineNormal)
                            .strokeBorder(viewModel.gender == gender ? .black : .clear)
                            .aspectRatio(8/11, contentMode: .fit)
                            .overlay {
                                Text(gender.rawValue)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 112)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: viewModel.gender) { _, newValue in
            if viewModel.step != 3 { return }
            viewModel.canNextStep = newValue != .UNKNOWN
        }
    }
}
