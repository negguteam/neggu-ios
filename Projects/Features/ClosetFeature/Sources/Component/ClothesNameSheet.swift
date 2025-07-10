//
//  ClothesNameSheet.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import Core
import NegguDS

import SwiftUI

struct ClothesNameSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var clothesName: String
    
    @State private var nameString: String
    
    var validateField: Bool {
        nameString.split(separator: " ").count > 0
    }
    
    init(clothesName: Binding<String>) {
        self._clothesName = clothesName
        nameString = clothesName.wrappedValue
    }
    
    var body: some View {
        NegguSheet {
            VStack {
                TextField(
                    "",
                    text: $nameString,
                    prompt: Text("옷의 이름을 입력해주세요.").foregroundStyle(.labelInactive)
                )
                .negguFont(.body2)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.bgAlt)
                }
                
                Spacer()
                
                Button {
                    clothesName = nameString.split(separator: " ").joined(separator: " ")
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("수정하기")
                                .negguFont(.body1b)
                                .foregroundStyle(.white)
                        }
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 48)
        } header: {
            Text("옷의 이름")
                .negguFont(.title3)
                .foregroundStyle(.labelNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onChange(of: nameString) { oldValue, newValue in
            if oldValue.isEmpty && newValue == " " {
                nameString.removeAll()
            }
        }
    }
}
