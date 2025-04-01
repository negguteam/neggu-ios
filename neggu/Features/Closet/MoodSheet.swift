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
    let isSingleSelection: Bool
    
    var selectionLimit: Int {
        isSingleSelection ? 1 : 3
    }
    
    init(selectedMoodList: Binding<[Mood]>, isSingleSelection: Bool = false) {
        self._selectedMoodList = selectedMoodList
        self.isSingleSelection = isSingleSelection
    }
    
    var body: some View {
        NegguSheet {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(Mood.allCasesArray) { mood in
                        let isSelected = selectedMoodList.contains(mood)
                        
                        Button {
                            if isSelected {
                                selectedMoodList.removeAll(where: { $0 == mood })
                            } else {
                                if isSingleSelection {
                                    if selectedMoodList.isEmpty {
                                        selectedMoodList.append(mood)
                                    } else {
                                        selectedMoodList[0] = mood
                                    }
                                } else {
                                    if selectedMoodList.count >= selectionLimit { return }
                                    selectedMoodList.append(mood)
                                }
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
                .padding(.horizontal, 48)
                .padding(.bottom, 76)
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
                .padding(.horizontal, 48)
                .padding(.top, 20)
                .padding(.bottom)
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
        } header: {
            HStack {
                Text("옷의 스타일")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if !selectedMoodList.isEmpty {
                    Button {
                        selectedMoodList.removeAll()
                        dismiss()
                    } label: {
                        Image(.refresh)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
        }
    }
}

#Preview {
    MoodSheet(selectedMoodList: .constant([]))
}
