//
//  Routable.swift
//  BaseFeature
//
//  Created by 유지호 on 7/9/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public protocol Routable: Hashable, Identifiable {
    func makeView() -> AnyView
}

public struct AnyRoutable: Routable {
    private let base: any Routable
    
    public init<R: Routable>(_ routable: R) {
        self.base = routable
    }

    
    public func makeView() -> AnyView {
        base.makeView()
    }
    
    public var id: String { "\(self)" }
    
    public static func == (lhs: AnyRoutable, rhs: AnyRoutable) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}
