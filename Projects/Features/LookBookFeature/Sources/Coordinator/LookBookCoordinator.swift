//
//  LookBookCoordinator.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Networks

import BaseFeature
import ClosetFeatureInterface
import LookBookFeatureInterface

import SwiftUI
import Combine

public final class LookBookCoordinator: BaseCoordinator {
    
    public weak var rootCoordinator: (any MainCoordinatorable)?
    
    private var bag = Set<AnyCancellable>()
    
    private let closetBuilder: any ClosetFeatureBuildable
    private let lookBookBuilder: any LookBookFeatureBuildable
    
    public init(
        closetBuilder: any ClosetFeatureBuildable,
        lookBookBuilder: any LookBookFeatureBuildable
    ) {
        self.closetBuilder = closetBuilder
        self.lookBookBuilder = lookBookBuilder
        super.init()
        
        $path
            .withUnretained(self)
            .sink { owner, path in
                owner.rootCoordinator?.showGnb = path.isEmpty
            }.store(in: &bag)
    }
    
    deinit {
        bag = .init()
    }
    
    
    @ViewBuilder
    public func buildScene(_ scene: MainScene) -> some View {
        switch scene {
        case .lookBookMain:
            lookBookBuilder.makeMain()
        case .lookBookDetail(let id):
            lookBookBuilder.makeDetail(id)
        case .lookBookRegister:
            lookBookBuilder.makeRegister()
            
        case .clothesDetail(let clothesID):
            closetBuilder.makeDetail(self, clothesID)
        case .clothesRegister(let entry):
            closetBuilder.makeRegister(self, entry)
        default:
            EmptyView()
        }
    }
    
}
