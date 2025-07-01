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
    
    @Binding var selectedColor: ColorFilter?
    
    var body: some View {
        NegguSheet {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(ColorFilter.allCases) { color in
                        Button {
                            if selectedColor == color {
                                selectedColor = nil
                            } else {
                                selectedColor = color
                            }
                            
                            dismiss()
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(color.color)
                                    .strokeBorder(color.color == .white ? .lineAlt : .clear)
                                    .frame(width: 24, height: 24)
                                
                                Text(color.title)
                                    .negguFont(.body2)
                                    .foregroundStyle(selectedColor == color ? .negguSecondary : .labelNormal)
                                
                                Spacer()
                            }
                            .frame(height: 52)
                        }
                    }
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 56)
            }
            .scrollIndicators(.hidden)
        } header: {
            HStack {
                Text("색상")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if selectedColor != nil {
                    Button {
                        selectedColor = nil
                        dismiss()
                    } label: {
                        NegguImage.Icon.refresh
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
        }
    }
}
