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
        ScrollView {
            VStack {
                Text("선호하는 분위기를 알려주세요")
                    .negguFont(.title4)
                    .foregroundStyle(.labelNormal)
                    .padding(.bottom)
                
                Text("좋아하는 분위기를 3가지 이상 알려주세요")
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
                                viewModel.moodList.remove(mood)
                            } else {
                                viewModel.moodList.insert(mood)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(setButtonColor(mood))
                                .strokeBorder(setButtonBorderColor(mood))
                                .frame(height: 220)
                                .overlay {
                                    Text(mood.rawValue)
                                }
                        }
                    }
                }
            }
            .padding(.top, 40)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            print("MoodView")
            viewModel.canNextStep = false
            
            viewModel.nextAction = {
                viewModel.register {
                    if $0 { authCoordinator.push(.complete) }
                }
            }
            
            viewModel.beforeAction = {
                viewModel.step -= 1
                viewModel.moodList.removeAll()
            }
        }
        .onChange(of: viewModel.moodList) { _, newValue in
            viewModel.canNextStep = newValue.count >= 3
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
