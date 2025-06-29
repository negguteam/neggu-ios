//
//  AuthFeatureBuilder.swift
//  AuthFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import AuthFeatureInterface

import SwiftUI

public final class AuthFeatureBuilder: AuthFeatureBuildable {
    
    private let signUpViewModel: SignUpViewModel = DIContainer.shared.resolve(SignUpViewModel.self)
    
    public init() { }
    
    
    public func makeOnboarding() -> AnyView {
        OnboardingView()
            .eraseToAnyView()
    }
    
    public func makeLogin() -> AnyView {
        let viewModel = DIContainer.shared.resolve(LoginViewModel.self)
        let view = LoginView(viewModel: viewModel)
        return view.eraseToAnyView()
    }
    
    public func makeSignUp() -> AnyView {
        SignUpView(viewModel: signUpViewModel)
            .eraseToAnyView()
    }
    
    public func makeSignUpComplete() -> AnyView {
        SignUpCompleteView()
            .eraseToAnyView()
    }
    
}
