//
//  Coordinatable.swift
//  BaseFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public protocol Coordinatable {
    var routers: NavigationPath { get set }
    var sheet: AnyRoutable? { get set }
    var fullScreen: AnyRoutable? { get set }
    
    func push(_ router: any Routable)
    func pop()
    func popToRoot()
    
    func present(_ router: any Routable)
    func dismiss()
    
    func fullScreen(_ router: any Routable)
    func dismissFullScreen()
}
