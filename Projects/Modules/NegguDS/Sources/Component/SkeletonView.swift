//
//  SkeletonView.swift
//  neggu
//
//  Created by 유지호 on 4/14/25.
//

import SwiftUI

public struct SkeletonView: View {
    @State private var isAnimating: Bool = false
    
    public init() { }
    
    public var body: some View {
        Rectangle()
            .fill(.clear)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRadius = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRadius * 2
                    
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.bgAlt)
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRadius)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        .offset(x: isAnimating ? maxX : minX)
                }
            }
            .clipped()
            .compositingGroup()
            .onAppear {
                if isAnimating { return }
                
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .onDisappear {
                isAnimating = false
            }
    }
    
    private var rotation: Double {
        return 5
    }
    
    private var animation: Animation {
        .easeInOut(duration: 2)
        .repeatForever(autoreverses: false)
    }
}

#Preview {
    SkeletonView()
}
