//
//  AuthCoordinator.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import BaseFeature
import AuthFeatureInterface

import SwiftUI

public final class AuthCoordinator: Coordinator {
    
    @Published public var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    private let builder: any AuthFeatureBuildable = AuthFeatureBuilder()
    
    public init() { }
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .onboarding:
            builder.makeOnboarding()
        case .login:
            builder.makeLogin()
        case .signUp:
            builder.makeSignUp()
        case .complete:
            builder.makeSignUpComplete()
        }
    }
    
    
    public enum Destination: Sceneable {
        case onboarding
        case login
        case signUp
        case complete
        
        public var id: String { "\(self)" }
    }
    
}
