//
//  BaseRouter.swift
//  BaseFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

open class BaseRouter: Routable, ObservableObject {
    
    public init() { }
    
    open func makeView() -> AnyView {
        AnyView(EmptyView())
    }
    
    public static func == (lhs: BaseRouter, rhs: BaseRouter) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
