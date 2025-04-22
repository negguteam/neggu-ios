//
//  NameEditView.swift
//  neggu
//
//  Created by 유지호 on 4/18/25.
//

import SwiftUI

struct NameEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var nameString: String = ""
    @State private var isValidName: Bool = true
    
    @FocusState private var focus: Bool
    
    private let placeholder: String
    
    init(name: String) {
        self.nameString = name
        self.placeholder = name
    }
    
    var body: some View {
        NegguSheet {
            VStack {
                HStack {
                    TextField(
                        "",
                        text: $nameString,
                        prompt: Text(placeholder).foregroundStyle(.labelInactive)
                    )
                    .focused($focus)
                    
                    Button {
                        nameString.removeAll()
                    } label: {
                        Image(.xSmall)
                    }
                    .opacity(nameString.count > 0 ? 1 : 0)
                    .disabled(nameString.count == 0)
                }
                .negguFont(.body2)
                .foregroundStyle(.labelNormal)
                .frame(height: 56)
                .padding(.horizontal)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.bgAlt)
                        .strokeBorder(isValidName ? .bgAlt : .warning)
                }
                
                if !isValidName {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.warningAlt)
                        .frame(height: 32)
                        .overlay {
                            HStack {
                                Image(.xSmall)
                                
                                Text("영소문자, 한글, 숫자 포함 7자까지 가능해요")
                                    .negguFont(.body3b)
                                    .lineLimit(1)
                            }
                            .foregroundStyle(.warning)
                        }
                }
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(.negguSecondary)
                    .frame(height: 56)
                    .overlay {
                        Text("수정하기")
                            .negguFont(.body1b)
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        editAction()
                    }
                
                Spacer()
            }
            .padding(.horizontal, 48)
        } header: {
            Text("닉네임")
                .negguFont(.title3)
                .foregroundStyle(.labelNormal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            focus = true
        }
        .onChange(of: nameString) { oldValue, newValue in
            if !isValidName {
                isValidName = true
            }
            
            if oldValue.isEmpty && newValue == " " {
                nameString.removeAll()
            }
        }
    }
    
    private func editAction() {
        if !nameString.isValidNickname() {
            isValidName = false
            return
        }
        
        focus = false
        
        if nameString == placeholder {
            dismiss()
            return
        }
        
        // TODO: API Call
        dismiss()
    }
}
