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
import Combine

public final class ClosetRouter: BaseCoordinator, ClosetRoutable {
    
    private var bag = Set<AnyCancellable>()
    
    private weak var tabRouter: (any TabRoutable)?
    private let closetBuilder: any ClosetFeatureBuildable
    
    public init(
        tabRouter: any TabRoutable,
        closetBuilder: any ClosetFeatureBuildable
    ) {
        self.tabRouter = tabRouter
        self.closetBuilder = closetBuilder
        super.init()
        
        $routers
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, routers in
                owner.tabRouter?.showGnb = routers.isEmpty
            }.store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
        debugPrint("\(self) deinit")
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
    
    public func presentRegister(_ image: UIImage, _ clothes: ClothesRegisterEntity) {
        let router = ClothesRegisterRouter(
            rootRouter: self,
            closetBuilder: closetBuilder,
            entry: .register(image, clothes)
        )
        fullScreen(router)
    }
    
}
