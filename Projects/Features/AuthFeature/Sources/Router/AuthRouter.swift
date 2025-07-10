//
//  AuthRouter.swift
//  AuthFeature
//
//  Created by 유지호 on 7/9/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import AuthFeatureInterface

import SwiftUI

public final class AuthRouter: BaseCoordinator, AuthRoutable {
    
    private let builder = AuthFeatureBuilder()
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public func start(_ isFirstVisit: Bool) -> AnyView {
        if isFirstVisit {
            builder.makeOnboarding()
        } else {
            builder.makeLogin(router: self)
        }
    }
    
    public func routeToSignUp() {
        let router = SignUpRouter(rootRouter: self, builder: builder)
        push(router)
    }
    
}
