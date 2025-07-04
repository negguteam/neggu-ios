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
import RootFeature
import AuthFeature
import ClosetFeature

import SwiftUI

extension App {
    
    var container: DIContainer { DIContainer.shared }
    
    func registerDependency() {
        container.register(LoginViewModel.self) {
            let authService = DefaultAuthService()
            return LoginViewModel(authService: authService)
        }
        
        container.register(SignUpViewModel.self) {
            let authService = DefaultAuthService()
            return SignUpViewModel(authService: authService)
        }
        
        container.register(ClosetUsecase.self) {
//            return DefaultClosetUsecase(closetService: DefaultClosetService())
            return MockClosetUsecase()
        }
        
        container.register(LookBookUsecase.self) {
//            return DefaultLookBookUsecase(lookBookService: DefaultLookBookService())
            return MockLookBookUsecase()
        }
        
        container.register(UserUsecase.self) {
//            return DefaultUserUsecase(userService: DefaultUserService())
            return MockUserUsecase()
        }
    }
    
}
