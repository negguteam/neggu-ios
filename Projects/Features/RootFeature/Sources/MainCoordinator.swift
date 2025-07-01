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

import SwiftUI

public final class MainCoordinator: MainCoordinatorable {

    @Published public var activeTab: NegguTab = .closet
    @Published public var showGnb: Bool = true
    @Published public var isGnbOpened: Bool = false
    
    @Published public var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    public init() { }
    
    
    @ViewBuilder
    public func buildScene() -> some View {
        RootView(mainCoordinator: self)
    }
    
    public func makeClosetCoordinator() -> ClosetCoordinator {
        let coordinator = ClosetCoordinator()
        coordinator.rootCoordinator = self
        return coordinator
    }
    
    public func makeLookBookCoordinator() -> LookBookCoordinator {
        let coordinator = LookBookCoordinator()
        coordinator.rootCoordinator = self
        return coordinator
    }
    
    public enum Destination: Sceneable {        
        public var id: String { "\(self)" }
    }
    
}


public final class LookBookCoordinator: Coordinator {
    
    @Published public var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    public weak var rootCoordinator: (any MainCoordinatorable)?
    
    public init() { }
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        Color.red
    }
    
    public enum Destination: Sceneable {
        case main
        case detail
        case register
        
        public var id: String { "\(self)" }
    }
    
}
