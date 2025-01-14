//
//  NegguCTAButton.swift
//  neggu
//
//  Created by 유지호 on 1/14/25.
//

import SwiftUI

struct NegguCTAButton: View {
    var body: some View {
        HStack {
            Image(.negguStar)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text("네가 좀 꾸며줘!")
                .negguFont(.body2b)
                .overlay {
                    RadialGradient(
                        colors: [
                            .negguGradient1,
                            .negguGradient2,
                            .negguGradient3,
                            .negguGradient4,
                            .negguGradient5,
                            .negguGradient6
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 60
                    )
                    
                    LinearGradient(
                        colors: [
                            .black.opacity(0.6),
                            .white.opacity(0.6),
                            .black.opacity(0.6),
                            .white.opacity(0.6),
                            .black.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blendMode(.difference)
                    
                    LinearGradient(
                        colors: [
                            .black,
                            .white,
                            .black,
                            .white,
                            .black
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blendMode(.screen)
                }
                .mask {
                    Text("네가 좀 꾸며줘!")
                        .negguFont(.body2b)
                }
        }
        .frame(height: 44)
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 100)
                .fill(.negguPrimary)
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 4,
                    x: 4,
                    y: 4
                )
                .shadow(
                    color: .black.opacity(0.1),
                    radius: 10,
                    y: 4
                )
        }
    }
}

#Preview {
    NegguCTAButton()
}
