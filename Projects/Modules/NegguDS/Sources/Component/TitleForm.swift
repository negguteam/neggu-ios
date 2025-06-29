//
//  TitleForm.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

public struct TitleForm<Content: View>: View {
    private let title: String
    private let isNeccsory: Bool
    private var spacing: CGFloat?
    private let content: () -> Content
    
    public init(
        _ title: String,
        isNessesory: Bool = false,
        spacing: CGFloat? = 12,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.isNeccsory = isNessesory
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment:. leading, spacing: spacing) {
            HStack(spacing: 4) {
                Text(title)
                    .foregroundStyle(.labelNormal)
                
                if isNeccsory {
                    Text("*")
                        .foregroundStyle(.systemWarning)
                }
            }
            .negguFont(.body1b)
            .padding(.bottom, 20)
            
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
