//
//  SignUpGenderView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import Core
import NegguDS

import SwiftUI

struct SignUpGenderView: View {
    @ObservedObject private var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
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
                    let isSelected = viewModel.gender == gender
                    
                    Button {
                        viewModel.genderDidSelect.send(isSelected ? .UNKNOWN : gender)
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isSelected ? .negguSecondaryAlt : .white)
                            .strokeBorder(isSelected ? .negguSecondary : .labelAlt)
                            .frame(width: 80, height: 48)
                            .overlay {
                                Text(gender.title)
                                    .negguFont(.body1b)
                                    .foregroundStyle(isSelected ? .negguSecondary : .labelAlt)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 128)
    }
}
