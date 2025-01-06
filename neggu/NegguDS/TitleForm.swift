//
//  TitleForm.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

struct TitleForm<Content: View>: View {
    let title: String
    var spacing: CGFloat?
    let content: () -> Content
    
    init(_ title: String, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        VStack(alignment:. leading, spacing: spacing) {
            Text(title)
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
