//
//  LookBookRegisterRouter.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

public final class LookBookRegisterRouter: BaseRouter, LookBookRegisterRoutable {
    
    private let rootRouter: Coordinatable
    private let builder: LookBookFeatureBuildable

    public init(rootRouter: Coordinatable, builder: LookBookFeatureBuildable) {
        self.rootRouter = rootRouter
        self.builder = builder
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public override func makeView() -> AnyView {
        builder.makeRegister(self)
    }
    
    public func dismiss() {
        rootRouter.dismissFullScreen()
    }
    
}
