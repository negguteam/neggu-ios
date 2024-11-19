//
//  NegguAlert.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct NegguAlert: ViewModifier {
    @Binding var showAlert: Bool
    
    let title: String
    let description: String
    
    let buttonAction: (() -> Void)?
    
    init(
        showAlert: Binding<Bool>,
        title: String,
        description: String,
        buttonAction: (() -> Void)? = nil
    ) {
        self._showAlert = showAlert
        self.title = title
        self.description = description
        self.buttonAction = buttonAction
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if showAlert {
                Color.bgDimmed.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 36) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .negguFont(.title4)
                            .foregroundStyle(.labelNormal)
                        
                        if !description.isEmpty {
                            Text(description)
                                .negguFont(.body2)
                                .foregroundStyle(.labelAlt)
                        }
                    }
                    
                    HStack {
                        Button {
                            showAlert = false
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.clear)
                                .frame(height: 48)
                                .overlay {
                                    Text("이어서 등록하기")
                                        .negguFont(.body2b)
                                        .foregroundStyle(.labelInactive)
                                }
                        }
                        
                        Button {
                            buttonAction?()
                        } label: {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.warning)
                                .frame(height: 48)
                                .overlay {
                                    Text("그만하기")
                                        .negguFont(.body2b)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.top, 48)
                .padding(.bottom, 24)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal, 32)
            }
        }
        .animation(.smooth, value: showAlert)
    }
}

extension View {
    
    func negguAlert(
        showAlert: Binding<Bool>,
        title: String,
        description: String = "",
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        modifier(NegguAlert(showAlert: showAlert, title: title, description: description, buttonAction: buttonAction))
    }
    
}
