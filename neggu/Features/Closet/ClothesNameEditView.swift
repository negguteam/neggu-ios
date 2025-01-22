//
//  ClothesNameEditView.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct ClothesNameEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var clothesName: String
    @State private var nameString: String = ""
    
    let placeholder: String
    
    var validateField: Bool {
        nameString.split(separator: " ").count > 0
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
            
            Text("수정하기")
                .negguFont(.title3)
                .foregroundStyle(.labelNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 30)
            
            TextField(
                "",
                text: $nameString,
                prompt: Text(placeholder).foregroundStyle(.labelInactive)
            )
            .negguFont(.body2)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.bgAlt)
            }
            .onChange(of: nameString) { oldValue, newValue in
                if oldValue.isEmpty && newValue == " " {
                    nameString.removeAll()
                }
            }
            
            Button {
                if nameString.isEmpty { return }
                clothesName = nameString.split(separator: " ").joined(separator: " ")
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(!validateField ? .labelInactive : .negguSecondary)
                    .disabled(!validateField)
                    .frame(height: 56)
                    .overlay {
                        Text("수정하기")
                            .negguFont(.body2b)
                            .foregroundStyle(.white)
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 48)
        .padding(.top, 20)
    }
}

#Preview {
    ClothesNameEditView(clothesName: .constant(""), placeholder: "")
}
