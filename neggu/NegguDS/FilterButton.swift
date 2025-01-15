//
//  FilterButton.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//


import SwiftUI

struct FilterButton: View {
    let title: String
    let buttonAction: () -> Void
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            HStack(spacing: 4) {
                Text(title)
                    .negguFont(.body2b)
                
                Image(systemName: "chevron.down")
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(.labelAssistive)
            .frame(height: 35)
            .padding(.leading, 12)
            .padding(.trailing, 8)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(.bgAlt)
            }
        }
    }
}
