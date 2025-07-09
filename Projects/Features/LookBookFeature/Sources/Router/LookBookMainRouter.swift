//
//  LookBookMainRouter.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/9/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Domain

import BaseFeature
import LookBookFeatureInterface
import ClosetFeatureInterface

import SwiftUI

public final class LookBookMainRouter: BaseCoordinator, LookBookMainRoutable {
    
    private let tabRouter: any TabRoutable
    private let lookBookBuilder: any LookBookFeatureBuildable
    private let closetBuilder: any ClosetFeatureBuildable
    
    public init(
        tabRouter: any TabRoutable,
        lookBookBuilder: any LookBookFeatureBuildable,
        closetBuilder: any ClosetFeatureBuildable
    ) {
        self.tabRouter = tabRouter
        self.lookBookBuilder = lookBookBuilder
        self.closetBuilder = closetBuilder
    }
    
    public func start() -> AnyView {
        lookBookBuilder.makeMain(self)
    }
    
    public func routeToDetail(id: String) {
        let router = LookBookDetailRouter(
            rootRouter: self,
            lookBookBuilder: lookBookBuilder,
            closetBuilder: closetBuilder,
            lookBookID: id
        )
        push(router)
    }
    
    public func routeToRegister() {
        let router = LookBookRegisterRouter(
            rootRouter: self,
            builder: lookBookBuilder
        )
        push(router)
    }
    
    public func fullScreenRegister() {
        let router = LookBookRegisterRouter(
            rootRouter: self,
            builder: lookBookBuilder
        )
        fullScreen(router)
    }
    
    public func routeToSetting() {
        let router = SettingRouter(
            rootRouter: self,
            builder: lookBookBuilder
        )
        push(router)
    }
    
    public func switchTab(_ tab: NegguTab) {
        tabRouter.switchTab(tab)
    }
    
}
