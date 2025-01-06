//
//  SignUpView.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                Capsule()
                    .fill(.black.opacity(0.1))
                    .overlay(alignment: .topLeading) {
                        Capsule()
                            .fill(.orange40)
                            .frame(width: CGFloat(viewModel.step) * proxy.size.width / 3, height: 8)
                    }
            }
            .frame(width: 204, height: 8)
            
            Text("STEP \(viewModel.step)/3")
                .negguFont(.caption)
                .foregroundStyle(.labelAssistive)
                .padding(.bottom, 36)
            
            TabView(selection: $viewModel.step) {
                SignUpNicknameView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
                
                SignUpGenderView()
                    .tag(2)
                    .toolbar(.hidden, for: .tabBar)
                
                SignUpMoodView()
                    .tag(3)
                    .toolbar(.hidden, for: .tabBar)
            }
            .background(.gray)
            
            VStack {
                Button {
                    viewModel.nextAction()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.canNextStep ? .negguSecondary : .labelAssistive)
                        .frame(height: 48)
                        .overlay {
                            Text("다음으로")
                                .negguFont(.body1b)
                                .foregroundStyle(.white)
                        }
                }
                .disabled(!viewModel.canNextStep)
                
                if viewModel.showAgeField {
                    HStack {
                        Button {
                            viewModel.beforeAction()
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
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                    .padding(.top)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
        .ignoresSafeArea(.keyboard)
        .animation(.smooth, value: viewModel.step)
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthViewModel())
}
