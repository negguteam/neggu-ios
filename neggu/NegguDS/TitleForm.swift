//
//  TitleForm.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

struct TitleForm<Content: View>: View {
    let title: String
    let isNeccsory: Bool
    var spacing: CGFloat?
    let content: () -> Content
    
    init(
        _ title: String,
        isNessesory: Bool = false,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.isNeccsory = isNessesory
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        VStack(alignment:. leading, spacing: spacing) {
            HStack(spacing: 4) {
                Text(title)
                    .foregroundStyle(.labelNormal)
                
                if isNeccsory {
                    Text("*")
                        .foregroundStyle(.warning)
                }
            }
            .negguFont(.body1b)
            
            content()
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 28)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
        }
    }
}
