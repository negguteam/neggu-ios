//
//  View+Extension.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import SwiftUI

struct SizeKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    
    func heightChangePreference(completion: @escaping (CGFloat) -> Void) -> some View {
        self.overlay {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizeKey.self, value: proxy.size.height)
                    .onPreferenceChange(SizeKey.self, perform: completion)
            }
        }
    }
    
}
