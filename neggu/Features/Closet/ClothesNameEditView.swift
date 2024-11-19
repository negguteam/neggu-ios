//
//  ClothesNameEditView.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct ClothesNameEditView: View {
    @Binding var editedModelName: String
    
    let clothesName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("수정하기")
                .negguFont(.title3)
                .foregroundStyle(.labelNormal)
                .padding(.bottom, 40)
            
            TextField(
                "",
                text: $editedModelName,
                prompt: Text(clothesName).foregroundStyle(.labelInactive)
            )
            .negguFont(.body2)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.bgAlt)
            }
            
            Button {
                
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.negguSecondary)
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
        .padding(.top, 77)
    }
}

#Preview {
    ClothesNameEditView(editedModelName: .constant(""), clothesName: "회색 후드")
}
