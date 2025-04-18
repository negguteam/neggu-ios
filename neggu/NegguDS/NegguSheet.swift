//
//  NegguSheet.swift
//  neggu
//
//  Created by 유지호 on 4/2/25.
//

import SwiftUI

struct NegguSheet<Header: View, Content: View>: View {
    let header: () -> Header
    let content: () -> Content
    
    init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.content = content
        self.header = header
    }
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
                .padding(.bottom, 24)
            
            header()
                .padding(.horizontal, 48)
            
            content()
        }
        .padding(.top, 20)
    }
}

extension NegguSheet where Header == EmptyView, Content: View {
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.init(
            content: content,
            header: { EmptyView() }
        )
    }
    
}
