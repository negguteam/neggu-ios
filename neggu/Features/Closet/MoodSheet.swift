//
//  MoodSheet.swift
//  neggu
//
//  Created by 유지호 on 1/17/25.
//

import SwiftUI

struct MoodSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedMoodList: [Mood]
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
            
            HStack {
                Text("옷의 분위기")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if !selectedMoodList.isEmpty {
                    Button {
                        selectedMoodList.removeAll()
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(Mood.allCasesArray) { mood in
                        let isSelected = selectedMoodList.contains(mood)
                        
                        Button {
                            if isSelected {
                                selectedMoodList.removeAll(where: { $0 == mood })
                            } else {
                                if selectedMoodList.count >= 3 { return }
                                selectedMoodList.append(mood)
                            }
                        } label: {
                            HStack {
                                Text(mood.title)
                                    .negguFont(.body2)
                                
                                Spacer()
                            }
                            .foregroundStyle(isSelected ? .negguSecondary : .labelNormal)
                            .frame(height: 52)
                            .padding(.horizontal, 12)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isSelected ? .negguSecondaryAlt : .clear)
                            }
                        }
                    }
                }
                .padding(.bottom, 110)
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) {
                Button {
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedMoodList.isEmpty ? .bgInactive : .negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("선택완료")
                                .negguFont(.body1b)
                                .foregroundStyle(selectedMoodList.isEmpty ? .labelInactive : .labelRNormal)
                        }
                }
                .disabled(selectedMoodList.isEmpty)
                .padding(.top, 20)
                .padding(.bottom, 50)
                .background {
                    LinearGradient(
                        colors: [
                            Color(red: 248, green: 248, blue: 248, opacity: 0),
                            Color(red: 248, green: 248, blue: 248, opacity: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
        }
        .padding(.horizontal, 48)
        .padding(.top, 20)
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MoodSheet(selectedMoodList: .constant([]))
}
