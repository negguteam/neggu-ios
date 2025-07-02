//
//  MainCoordinator.swift
//  RootFeature
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Networks

import BaseFeature
import ClosetFeature
import ClosetFeatureInterface
import LookBookFeature
import LookBookFeatureInterface

import SwiftUI

public final class MainCoordinator: MainCoordinatorable {

    @Published public var activeTab: NegguTab = .closet
    @Published public var gnbState: GnbState = .main
    @Published public var showGnb: Bool = true
    @Published public var isGnbOpened: Bool = false
    
    @Published public var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    public init() { }
    
    
    @ViewBuilder
    public func start() -> some View {
        RootView(mainCoordinator: self)
    }
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .clothesRegister(let entry):
            let viewModel = ClothesRegisterViewModel(closetUsecase: DIContainer.shared.resolve(ClosetUsecase.self))
            let clothesRegisterView = ClothesRegisterView(viewModel: viewModel, entry: entry)
            clothesRegisterView.eraseToAnyView()
        }
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
        case clothesRegister(entry: ClothesEditType)
        
        public var id: String { "\(self)" }
    }
    
}
