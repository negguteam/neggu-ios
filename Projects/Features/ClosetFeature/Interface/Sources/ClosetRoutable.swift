//
//  ClosetRoutable.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Domain

import BaseFeature

import SwiftUI

public protocol ClosetRoutable: Coordinatable {
    var routers: NavigationPath { get set }
    
    func start() -> AnyView
    func presentDetail(id: String)
    func routeToRegister(_ image: UIImage, _ clothes: ClothesRegisterEntity)
}
