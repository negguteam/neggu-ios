//
//  SignUpMoodView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import SwiftUI

struct SignUpMoodView: View {
    @EnvironmentObject private var authCoordinator: AuthCoordinator
    @EnvironmentObject private var viewModel: AuthViewModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack {
                    Text("선호하는 분위기를 알려주세요")
                        .negguFont(.title4)
                        .foregroundStyle(.labelNormal)
                        .padding(.top, 40)
                        .padding(.bottom)
                        .id(0)
                    
                    Text("좋아하는 분위기를 최대 3가지 알려주세요")
                        .negguFont(.body3)
                        .foregroundStyle(.labelAssistive)
                        .padding(.bottom, 48)
                    
                    LazyVGrid(
                        columns: [GridItem](repeating: .init(.flexible(), spacing: 16), count: 2),
                        spacing: 14
                    ) {
                        ForEach(Mood.allCasesArray) { mood in
                            Button {
                                
                                if viewModel.moodList.contains(mood) {
                                    viewModel.moodList.removeAll(where: { $0 == mood })
                                } else {
                                    if viewModel.moodList.count >= 3 {
                                        return
                                    } else {
                                        viewModel.moodList.append(mood)
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(setButtonColor(mood))
                                    .strokeBorder(setButtonBorderColor(mood))
                                    .aspectRatio(8/11, contentMode: .fit)
                                    .overlay {
                                        Text(mood.rawValue)
                                    }
                            }
                        }
                    }
                }
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 28)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        .clear,
                        Color(red: 248, green: 248, blue: 248, opacity: 0.8),
                        Color(red: 248, green: 248, blue: 248, opacity: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 240)
                .allowsHitTesting(false)
            }
            .onChange(of: viewModel.step) { _, newValue in
                if newValue == 4 {
                    scrollProxy.scrollTo(0, anchor: .top)
                }
            }
            .onChange(of: viewModel.moodList) { _, newValue in
                if viewModel.step != 4 { return }
                viewModel.canNextStep = newValue.count >= 3
            }
        }
    }
    
    func setButtonColor(_ mood: Mood) -> Color {
        if viewModel.moodList.isEmpty || viewModel.moodList.contains(mood) {
            return .bgAlt
        } else {
            return .black.opacity(0.5)
        }
    }
    
    func setButtonBorderColor(_ mood: Mood) -> Color {
        viewModel.moodList.contains(mood) ? .black : .clear
    }
}
