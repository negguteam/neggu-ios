//
//  PresentationDependency.swift
//  neggu
//
//  Created by 유지호 on 8/8/24.
//

import SwiftUI

extension DIContainer {
    
    func registerPresentationDependencies() {
        register(LoginView.self) {
            return LoginView()
        }
        
        register(SignUpView.self) {
            return SignUpView()
        }
        
        register(SignUpCompleteView.self) {
            return SignUpCompleteView()
        }
    }
    
}
