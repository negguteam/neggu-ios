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
        OnboardingView().eraseToAnyView()
    }
    
    public func makeLogin(router: any AuthRoutable) -> AnyView {
        let viewModel = LoginViewModel(router: router, authUsecase: authUsecase)
        let view = LoginView(viewModel: viewModel)
        return view.eraseToAnyView()
    }
    
    public func makeSignUp(router: any SignUpRoutable) -> AnyView {
        let viewModel = SignUpViewModel(router: router, authUsecase: authUsecase)
        let view = SignUpView(viewModel: viewModel)
        return view.eraseToAnyView()
    }
    
    public func makeSignUpComplete(router: any SignUpCompleteRoutable) -> AnyView {
        guard let router = router as? SignUpCompleteRouter else { return AnyView(EmptyView()) }
        return SignUpCompleteView(router: router).eraseToAnyView()
    }
    
}
