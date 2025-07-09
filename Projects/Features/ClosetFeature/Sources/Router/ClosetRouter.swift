//
//  ClosetRouter.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/9/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Domain

import BaseFeature
import ClosetFeatureInterface

import SwiftUI

public final class ClosetRouter: BaseCoordinator, ClosetRoutable {
    
    private let closetBuilder: any ClosetFeatureBuildable
    
    public init(closetBuilder: any ClosetFeatureBuildable) {
        self.closetBuilder = closetBuilder
    }
    
    
    public func start() -> AnyView {
        closetBuilder.makeMain(self)
    }
    
    public func presentDetail(id: String) {
        let router = ClothesDetailRouter(
            rootRouter: self,
            closetBuilder: closetBuilder,
            clothesID: id
        )
        present(router)
    }
    
    public func routeToRegister(_ image: UIImage, _ clothes: ClothesRegisterEntity) {
        let router = ClothesRegisterRouter(
            rootRouter: self,
            closetBuilder: closetBuilder,
            entry: .register(image, clothes)
        )
        push(router)
    }
    
}
