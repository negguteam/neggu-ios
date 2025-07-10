//
//  ClothesRegisterRouter.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import ClosetFeatureInterface

import SwiftUI

public final class ClothesRegisterRouter: BaseRouter, ClothesRegisterRoutable {
    
    private let rootRouter: any Coordinatable
    private let closetBuilder: any ClosetFeatureBuildable
    private let entry: ClothesEditType
    
    init(
        rootRouter: any Coordinatable,
        closetBuilder: any ClosetFeatureBuildable,
        entry: ClothesEditType
    ) {
        self.rootRouter = rootRouter
        self.closetBuilder = closetBuilder
        self.entry = entry
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public override func makeView() -> AnyView {
        closetBuilder.makeRegister(self, entry)
    }
    
    public func presentDetail(id: String) {
        let router = ClothesDetailRouter(
            rootRouter: rootRouter,
            closetBuilder: closetBuilder,
            clothesID: id
        )
        rootRouter.present(router)
    }
    
    public func dismiss() {
        rootRouter.dismissFullScreen()
    }
    
}
