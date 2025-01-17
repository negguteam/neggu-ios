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
                .padding(.top, 40)
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
                            .frame(height: 256)
                            .overlay {
                                Text(gender.rawValue)
                            }
                    }
                }
            }
            
            Spacer()
        }
        .onAppear {
            print("GenderView")
            viewModel.canNextStep = viewModel.gender != .UNKNOWN
            
            viewModel.nextAction = {
                viewModel.step += 1
            }
            
            viewModel.beforeAction = {
                viewModel.step -= 1
                viewModel.gender = .UNKNOWN
            }
        }
        .onChange(of: viewModel.gender) { _, newValue in
            viewModel.canNextStep = newValue != .UNKNOWN
        }
    }
}
