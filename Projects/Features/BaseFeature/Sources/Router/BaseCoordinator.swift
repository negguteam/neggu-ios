//
//  BaseCoordinator.swift
//  BaseFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

open class BaseCoordinator: Coordinatable, ObservableObject {
    
    @Published open var routers: NavigationPath = .init()
    @Published open var sheet: AnyRoutable?
    @Published open var fullScreen: AnyRoutable?
    
    public init() { }
    
    
    open func push(_ router: any Routable) {
        routers.append(AnyRoutable(router))
    }
    
    open func pop() {
        routers.removeLast(routers.isEmpty ? 0 : 1)
    }
    
    open func popToRoot() {
        routers.removeLast(routers.count)
    }
    
    open func present(_ router: any Routable) {
        sheet = AnyRoutable(router)
    }
    
    open func dismiss() {
        sheet = nil
    }
    
    open func fullScreen(_ router: any Routable) {
        fullScreen = AnyRoutable(router)
    }
    
    open func dismissFullScreen() {
        fullScreen = nil
    }
    
}
