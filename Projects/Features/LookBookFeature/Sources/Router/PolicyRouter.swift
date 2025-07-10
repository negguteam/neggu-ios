//
//  PolicyRouter.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

public final class PolicyRouter: BaseRouter, PolicyRoutable {
    
    private let rootRouter: Coordinatable
    private let builder: LookBookFeatureBuildable
    private let policyType: PolicyType
    
    public init(
        rootRouter: Coordinatable,
        builder: LookBookFeatureBuildable,
        policyType: PolicyType
    ) {
        self.rootRouter = rootRouter
        self.builder = builder
        self.policyType = policyType
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public override func makeView() -> AnyView {
        builder.makePolicy(self, policyType: policyType)
    }
    
    public func pop() {
        rootRouter.pop()
    }
    
}
