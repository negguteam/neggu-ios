//
//  View+Extension.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import SwiftUI

public struct SizeKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

public extension View {
    
    func heightChangePreference(completion: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: proxy.size.height)
                    .onPreferenceChange(SizeKey.self, perform: completion)
            }
        }
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    @MainActor
    func snapshot(scale: CGFloat? = nil) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale ?? UIScreen.main.scale
        return renderer.uiImage
    }
    
}
