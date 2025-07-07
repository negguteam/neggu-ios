//
//  ColorSheet.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//

import NegguDS

import BaseFeature

import SwiftUI

struct ColorSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var colorSelection: ColorFilter?
    
    @State private var selectedColor: ColorFilter?
    
    init(selection: Binding<ColorFilter?>) {
        self._colorSelection = selection
    }
    
    var body: some View {
        NegguSheet {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(ColorFilter.allCases) { color in
                        let isSelected = selectedColor == color
                        
                        Button {
                            selectedColor = isSelected ? nil : color
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(color.color)
                                    .strokeBorder(color.color == .white ? .lineAlt : .clear)
                                    .frame(width: 24, height: 24)
                                
                                Text(color.title)
                                    .negguFont(.body2)
                                
                                Spacer()
                            }
                            .foregroundStyle(.labelNormal)
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
                    colorSelection = selectedColor
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("선택완료")
                                .negguFont(.body1b)
                                .foregroundStyle(.labelRNormal)
                        }
                }
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
                    .ignoresSafeArea()
                }
            }
        } header: {
            HStack {
                Text("색상")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if selectedColor != nil {
                    Button {
                        selectedColor = nil
                    } label: {
                        NegguImage.Icon.refresh
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
        }
        .onAppear {
            selectedColor = colorSelection
        }
    }
}
