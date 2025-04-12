//
//  GradientView.swift
//  neggu
//
//  Created by 유지호 on 4/13/25.
//

import SwiftUI

struct GradientView<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
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
