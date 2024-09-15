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
            let authViewModel = AuthViewModel()
            return LoginView(authViewModel: authViewModel)
        }
        
        register(EditNicknameView.self) {
            let viewModel = NicknameEditViewModel()
            return EditNicknameView(viewModel: viewModel)
        }
    }
    
}
