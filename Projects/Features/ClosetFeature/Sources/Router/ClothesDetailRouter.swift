//
//  ClothesDetailRouter.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Domain

import BaseFeature
import ClosetFeatureInterface

import SwiftUI

public final class ClothesDetailRouter: BaseRouter, ClothesDetailRoutable {
    
    private let rootRouter: any Coordinatable
    private let closetBuilder: any ClosetFeatureBuildable
    private let clothesID: String
    
    init(
        rootRouter: any Coordinatable,
        closetBuilder: any ClosetFeatureBuildable,
        clothesID: String
    ) {
        self.rootRouter = rootRouter
        self.closetBuilder = closetBuilder
        self.clothesID = clothesID
    }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public override func makeView() -> AnyView {
        closetBuilder.makeDetail(self, clothesID)
    }
    
    public func presentModify(_ clothes: ClothesEntity) {
        let router = ClothesRegisterRouter(
            rootRouter: rootRouter,
            closetBuilder: closetBuilder,
            entry: .modify(clothes)
        )
        rootRouter.fullScreen(router)
    }
    
    public func dismiss() {
        rootRouter.dismiss()
    }
    
}
