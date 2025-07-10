//
//  SignUpView.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import NegguDS

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel
    
    init(viewModel: SignUpViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                GeometryReader { proxy in
                    Capsule()
                        .fill(.black.opacity(0.1))
                        .overlay(alignment: .topLeading) {
                            Capsule()
                                .fill(.negguSecondary)
                                .frame(
                                    width: CGFloat(viewModel.step) * proxy.size.width / 4,
                                    height: 8
                                )
                        }
                }
                .frame(width: 204, height: 8)
                .animation(.smooth, value: viewModel.step)
                
                Text("STEP \(viewModel.step)/4")
                    .negguFont(.caption)
                    .foregroundStyle(.labelAssistive)
            }
            .padding(.top, 12)
            
            GeometryReader { proxy in
                ZStack {
                    SignUpNicknameView(viewModel: viewModel)
                        .offset(y: viewModel.step == 1 ? 0 : viewModel.step > 1 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 1 ? 1 : 0)
                    
                    SignUpAgeView(viewModel: viewModel)
                        .offset(y: viewModel.step == 2 ? 0 : viewModel.step > 2 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 2 ? 1 : 0)
                    
                    SignUpGenderView(viewModel: viewModel)
                        .frame(height: proxy.size.height)
                        .offset(y: viewModel.step == 3 ? 0 : viewModel.step > 3 ? -proxy.size.height : proxy.size.height)
                        .opacity(viewModel.step == 3 ? 1 : 0)
                    
                    SignUpMoodView(viewModel: viewModel)
                        .frame(height: proxy.size.height)
                        .offset(y: viewModel.step == 4 ? 0 : proxy.size.height)
                        .opacity(viewModel.step == 4 ? 1 : 0)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .animation(.smooth(duration: 0.5), value: viewModel.step)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 24) {
                        Button {
                            viewModel.nextButtonDidTap.send()
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.negguSecondary)
                                .frame(height: 56)
                                .overlay {
                                    Text("다음으로")
                                        .negguFont(.body1b)
                                        .foregroundStyle(.white)
                                }
                        }
                        
                        if viewModel.step > 1 {
                            HStack {
                                Button {
                                    viewModel.tapBackButton()
                                } label: {
                                    HStack(spacing: 0) {
                                        NegguImage.Icon.chevronLeft
                                        
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
        }
        .padding(.horizontal, 20)
        .background(.bgNormal)
    }
}
