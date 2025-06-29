//
//  AuthFeatureBuilder.swift
//  AuthFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import AuthFeatureInterface
import Networks

import SwiftUI

public final class AuthFeatureBuilder: AuthFeatureBuildable {
    
    private let signUpViewModel: SignUpViewModel = SignUpViewModel()
    
    public init() { }
    
    
    public func makeOnboarding() -> AnyView {
        OnboardingView()
            .eraseToAnyView()
    }
    
    public func makeLogin() -> AnyView {
        let viewModel = LoginViewModel()
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
