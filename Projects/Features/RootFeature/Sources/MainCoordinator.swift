//
//  MainCoordinator.swift
//  RootFeature
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import BaseFeature
import ClosetFeature
import LookBookFeature

import SwiftUI

public final class MainCoordinator: BaseCoordinator, MainCoordinatorable {

    @Published public var activeTab: NegguTab = .closet
    @Published public var gnbState: GnbState = .main
    @Published public var showGnb: Bool = true
    @Published public var isGnbOpened: Bool = false
    
    public weak var childCoordinator: (any Coordinator)?
    
    
    @ViewBuilder
    public func start() -> some View {
        RootView(mainCoordinator: self)
    }
    
    public func makeClosetCoordinator() -> ClosetCoordinator {
        let coordinator = ClosetCoordinator(closetBuilder: ClosetFeatureBuilder())
        coordinator.rootCoordinator = self
        return coordinator
    }
    
    public func makeLookBookCoordinator() -> LookBookCoordinator {
        let coordinator = LookBookCoordinator(
            closetBuilder: ClosetFeatureBuilder(),
            lookBookBuilder: LookBookFeatureBuilder()
        )
        
        coordinator.rootCoordinator = self
        return coordinator
    }
    
}
