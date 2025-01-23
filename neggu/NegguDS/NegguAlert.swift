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
    let leftContent: String
    let rightContent: String
    let buttonAction: (() -> Void)?
    
    init(
        showAlert: Binding<Bool>,
        title: String,
        description: String,
        leftContent: String,
        rightContent: String,
        buttonAction: (() -> Void)? = nil
    ) {
        self._showAlert = showAlert
        self.title = title
        self.description = description
        self.leftContent = leftContent
        self.rightContent = rightContent
        self.buttonAction = buttonAction
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if showAlert {
                Color.bgDimmed.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showAlert = false
                    }
                
                VStack(spacing: 20) {
                    Text(title)
                        .negguFont(.title4)
                        .foregroundStyle(.labelNormal)
                    
                    if !description.isEmpty {
                        Text(description)
                            .negguFont(.body2)
                            .foregroundStyle(.labelAlt)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            showAlert = false
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.clear)
                                .frame(height: 48)
                                .overlay {
                                    Text(leftContent)
                                        .negguFont(.body2)
                                        .foregroundStyle(.labelInactive)
                                }
                        }
                        
                        Button {
                            buttonAction?()
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.warning)
                                .frame(height: 48)
                                .overlay {
                                    Text(rightContent)
                                        .negguFont(.body2b)
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.horizontal, .bottom], 20)
                .padding(.top, 40)
                .background(.white)
                .clipShape(.rect(cornerRadius: 16))
                .padding(.horizontal, 32)
            }
        }
        .animation(.smooth(duration: 0.3), value: showAlert)
    }
}

extension View {
    
    func negguAlert(
        showAlert: Binding<Bool>,
        title: String,
        description: String = "",
        leftContent: String,
        rightContent: String,
        buttonAction: (() -> Void)? = nil
    ) -> some View {
        modifier(
            NegguAlert(
                showAlert: showAlert,
                title: title,
                description: description,
                leftContent: leftContent,
                rightContent: rightContent,
                buttonAction: buttonAction
            )
        )
    }
    
}
