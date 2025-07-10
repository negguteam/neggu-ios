//
//  AuthRoutable.swift
//  AuthFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature

import SwiftUI

public protocol AuthRoutable {
    var routers: NavigationPath { get set }
    
    func routeToSignUp()
}
