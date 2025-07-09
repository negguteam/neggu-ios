//
//  LookBookMainRoutable.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature

import SwiftUI

public protocol LookBookMainRoutable {
    var routers: NavigationPath { get set }
    
    func start() -> AnyView
    func routeToDetail(id: String)
    func routeToRegister()
    func routeToSetting()
    func switchTab(_ tab: NegguTab)
    func fullScreenRegister()
}
