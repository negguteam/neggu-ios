//
//  ColorSheet.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//

import SwiftUI

struct ColorSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedColor: ColorFilter?
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
            
            HStack {
                Text("카테고리")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
            }
            
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
                                
                                Text(color.id.uppercased())
                                    .negguFont(.body2)
                                    .foregroundStyle(selectedColor == color ? .negguSecondary : .labelNormal)
                                
                                Spacer()
                            }
                            .frame(height: 52)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 48)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    ContentView()
}
