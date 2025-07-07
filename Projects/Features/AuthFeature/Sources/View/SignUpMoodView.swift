//
//  SignUpMoodView.swift
//  neggu
//
//  Created by 유지호 on 1/4/25.
//

import Core
import NegguDS

import SwiftUI

struct SignUpMoodView: View {
    @EnvironmentObject private var viewModel: SignUpViewModel
    
    @State private var moodSelection: [Mood] = []
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                VStack(spacing: 24) {
                    Text("선호하는 스타일을 알려주세요")
                        .negguFont(.title4)
                        .foregroundStyle(.labelNormal)
                        .padding(.top, 40)
                        .padding(.bottom)
                        .id(0)
                    
                    Text("좋아하는 스타일을 최대 3가지 알려주세요")
                        .negguFont(.body3)
                        .foregroundStyle(.labelAssistive)
                        .padding(.bottom, 48)
                    
                    LazyVGrid(
                        columns: [GridItem](repeating: .init(.flexible(), spacing: 16), count: 2),
                        spacing: 14
                    ) {
                        ForEach(Mood.allCasesArray) { mood in
                            Button {
                                if moodSelection.contains(mood) {
                                    moodSelection.removeAll(where: { $0 == mood })
                                } else {
                                    if moodSelection.count >= 3 { return }
                                    moodSelection.append(mood)
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(setButtonColor(mood))
                                    .strokeBorder(setButtonBorderColor(mood))
                                    .frame(height: 48)
                                    .overlay {
                                        Text(mood.title)
                                            .negguFont(.body1b)
                                            .foregroundStyle(setButtonBorderColor(mood))
                                    }
                            }
                        }
                    }
                }
                .padding(.bottom, 128)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 28)
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .bgNormal.opacity(0.8), .bgNormal],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 240)
                .allowsHitTesting(false)
            }
            .onChange(of: viewModel.step) { _, newValue in
                if newValue == 4 {
                    scrollProxy.scrollTo(0, anchor: .top)
                    moodSelection.removeAll()
                }
            }
            .onChange(of: moodSelection) { _, newValue in
                viewModel.moodDidSelect.send(newValue)
            }
        }
    }
    
    private func setButtonColor(_ mood: Mood) -> Color {
        moodSelection.contains(mood) ? .negguSecondaryAlt : .white
    }
    
    private func setButtonBorderColor(_ mood: Mood) -> Color {
        moodSelection.contains(mood) ? .negguSecondary : .labelAlt
    }
}
