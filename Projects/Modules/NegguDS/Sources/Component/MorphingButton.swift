//
//  MorphingButton.swift
//  NegguDS
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public struct MorphingButton<Label: View, Content: View, ExpandedContent: View>: View {
    @Binding var showExpandedContent: Bool
    
    @State private var showFullScreenCover: Bool = false
    @State private var animateContent: Bool = false
    @State private var viewPosition: CGRect = .zero
    
    public let label: () -> Label
    public let content: () -> Content
    public let expandedContent: () -> ExpandedContent
    
    public let backgroundColor: Color

    public init(
        showExpandedContent: Binding<Bool>,
        label: @escaping () -> Label,
        content: @escaping () -> Content,
        expandedContent: @escaping () -> ExpandedContent,
        backgroundColor: Color = .black
    ) {
        self._showExpandedContent = showExpandedContent
        self.label = label
        self.content = content
        self.expandedContent = expandedContent
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        Button {
            showExpandedContent.toggle()
//            showFullScreenCover.toggle()
        } label: {
            label()
        }
        .background(backgroundColor)
        .clipShape(.circle)
        .contentShape(.circle)
        .onGeometryChange(
            for: CGRect.self,
            of: { $0.frame(in: .global) },
            action: { newValue in viewPosition = newValue }
        )
        .opacity(showFullScreenCover ? 0 : 1)
        .onTapGesture {
            toggleFullScreenCover(status: !showExpandedContent)
        }
        .fullScreenCover(isPresented: $showFullScreenCover) {
            ZStack(alignment: .topLeading) {
                if animateContent {
                    content()
                        .transition(.blurReplace)
                } else {
                    label()
                        .transition(.blurReplace)
                }
            }
            .clipShape(.rect(cornerRadius: 20, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(backgroundColor)
            }
            .padding(.horizontal, animateContent ? 20 : 0)
            .padding(.bottom, animateContent ? 14 : 0)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: animateContent ? .bottom : .topLeading
            )
            .offset(
                x: animateContent ? 0 : viewPosition.minX,
                y: animateContent ? 0 : viewPosition.minY
            )
            .ignoresSafeArea(animateContent ? [] : .all)
            .task {
                try? await Task.sleep(for: .seconds(0.05))
                
                withAnimation(.interpolatingSpring(duration: 0.2, bounce: 0)) {
                    animateContent = true
                }
            }
            .presentationBackground(.clear)
            .onTapGesture {
                showFullScreenCover = false
            }
        }
    }
    
    private func toggleFullScreenCover(_ withAnimation: Bool = false, status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = !withAnimation
        
        withTransaction(transaction) {
            showFullScreenCover = status
        }
    }
}
