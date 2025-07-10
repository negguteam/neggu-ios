//
//  SignUpRouter.swift
//  AuthFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import AuthFeatureInterface

import SwiftUI

final class SignUpRouter: BaseRouter, SignUpRoutable {
    
    private let rootRouter: any Coordinatable
    private let builder: any AuthFeatureBuildable
    
    init(
        rootRouter: any Coordinatable,
        builder: any AuthFeatureBuildable
    ) {
        self.rootRouter = rootRouter
        self.builder = builder
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    override func makeView() -> AnyView {
        builder.makeSignUp(router: self)
    }
    
    func routeToComplete() {
        let router = SignUpCompleteRouter(
            rootRouter: rootRouter,
            builder: builder
        )
        rootRouter.switchRoot(router)
    }
    
}
