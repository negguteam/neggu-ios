//
//  RegisterDependency.swift
//  Neggu
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Networks

import BaseFeature
import AuthFeature

import SwiftUI

extension App {
    
    private var container: DIContainer { DIContainer.shared }
    
    func registerDependency() {
        container.register(LoginViewModel.self) {
            let authService = DefaultAuthService()
            return LoginViewModel(authService: authService)
        }
        
        container.register(SignUpViewModel.self) {
            let authService = DefaultAuthService()
            return SignUpViewModel(authService: authService)
        }
    }
    
}
