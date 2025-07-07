//
//  AuthFeatureBuilder.swift
//  AuthFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Domain

import AuthFeatureInterface

import SwiftUI

public final class AuthFeatureBuilder: AuthFeatureBuildable {
    
    private let authUsecase = DIContainer.shared.resolve(AuthUsecase.self)
    
    public init() { }
    
    
    public func makeOnboarding() -> AnyView {
        OnboardingView()
            .eraseToAnyView()
    }
    
    public func makeLogin() -> AnyView {
        let viewModel = LoginViewModel(authUsecase: authUsecase)
        let view = LoginView(viewModel: viewModel)
        return view.eraseToAnyView()
    }
    
    public func makeSignUp() -> AnyView {
        let viewModel = SignUpViewModel(authUsecase: authUsecase)
        let view = SignUpView(viewModel: viewModel)
        return view.eraseToAnyView()
    }
    
    public func makeSignUpComplete() -> AnyView {
        SignUpCompleteView()
            .eraseToAnyView()
    }
    
}
