//
//  GradientView.swift
//  neggu
//
//  Created by 유지호 on 4/13/25.
//

import SwiftUI

public struct GradientView<Content: View>: View {
    let content: () -> Content
    
    public init(content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        content()
            .overlay {
                Image(.gnbOpen)
                    .resizable()
                    .mask {
                        content()
                    }
            }
    }
}
