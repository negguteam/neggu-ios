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
        DispatchQueue.main.async {
            self.routers.append(AnyRoutable(router))
        }
    }
    
    open func pop() {
        DispatchQueue.main.async {
            self.routers.removeLast(self.routers.isEmpty ? 0 : 1)
        }
    }
    
    open func popToRoot() {
        DispatchQueue.main.async {
            self.routers.removeLast(self.routers.count)
        }
    }
    
    open func switchRoot(_ router: any Routable) {
        DispatchQueue.main.async {
            self.routers = .init([AnyRoutable(router)])
        }
    }
    
    open func present(_ router: any Routable) {
        DispatchQueue.main.async {
            self.sheet = AnyRoutable(router)
        }
    }
    
    open func dismiss() {
        DispatchQueue.main.async {
            self.sheet = nil
        }
    }
    
    open func fullScreen(_ router: any Routable) {
        DispatchQueue.main.async {
            self.fullScreen = AnyRoutable(router)
        }
    }
    
    open func dismissFullScreen() {
        DispatchQueue.main.async {
            self.fullScreen = nil
        }
    }
    
}
