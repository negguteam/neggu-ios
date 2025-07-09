//
//  SettingRouter.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

public final class SettingRouter: BaseRouter, SettingRoutable {
    
    private let rootRouter: Coordinatable
    private let builder: LookBookFeatureBuildable
    
    public init(rootRouter: Coordinatable, builder: LookBookFeatureBuildable) {
        self.rootRouter = rootRouter
        self.builder = builder
    }
    
    
    public override func makeView() -> AnyView {
        builder.makeSetting(self)
    }
    
    public func routeToPolicy(_ policyType: PolicyType) {
        let router = PolicyRouter(
            rootRouter: rootRouter,
            builder: builder,
            policyType: policyType
        )
        rootRouter.push(router)
    }
    
    public func pop() {
        rootRouter.pop()
    }
    
    public func popToRoot() {
        rootRouter.popToRoot()
    }
    
}
