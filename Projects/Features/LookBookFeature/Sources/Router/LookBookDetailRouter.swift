//
//  LookBookDetailRouter.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import ClosetFeatureInterface
import LookBookFeatureInterface

import SwiftUI

public final class LookBookDetailRouter: BaseRouter, LookBookDetailRoutable {
    
    private let rootRouter: any Coordinatable
    private let lookBookBuilder: any LookBookFeatureBuildable
    private let closetBuilder: any ClosetFeatureBuildable
    private let lookBookID: String
    
    public init(
        rootRouter: any Coordinatable,
        lookBookBuilder: any LookBookFeatureBuildable,
        closetBuilder: any ClosetFeatureBuildable,
        lookBookID: String
    ) {
        self.rootRouter = rootRouter
        self.lookBookBuilder = lookBookBuilder
        self.closetBuilder = closetBuilder
        self.lookBookID = lookBookID
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public override func makeView() -> AnyView {
        lookBookBuilder.makeDetail(self, lookBookID)
    }
    
    public func presentClothesDetail(id: String) {
        let router = closetBuilder.makeDetailRouter(
            rootRouter: rootRouter,
            builder: closetBuilder,
            id: id
        )
        rootRouter.present(router)
    }
    
    public func pop() {
        rootRouter.pop()
    }
    
}
