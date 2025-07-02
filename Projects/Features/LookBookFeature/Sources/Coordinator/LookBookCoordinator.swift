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

public final class LookBookCoordinator: Coordinator {
    
    @Published public var path: NavigationPath = .init() {
        didSet {
            rootCoordinator?.showGnb = path.isEmpty
        }
    }
    
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    public weak var rootCoordinator: (any MainCoordinatorable)?
    
    private let closetBuilder: any ClosetFeatureBuildable
    private let lookBookBuilder: any LookBookFeatureBuildable
    
    public init(
        closetBuilder: any ClosetFeatureBuildable,
        lookBookBuilder: any LookBookFeatureBuildable
    ) {
        self.closetBuilder = closetBuilder
        self.lookBookBuilder = lookBookBuilder
    }
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .main:
            lookBookBuilder.makeMain()
        case .detail(let id):
            lookBookBuilder.makeDetail(id)
        case .register:
            lookBookBuilder.makeRegister()
        
        case .clothesDetail(let id):
            closetBuilder.makeDetail(id)
        case .clothesRegister(let clothes):
            closetBuilder.makeRegister(.modify(clothes))
        }
    }
    
    public enum Destination: Sceneable {
        case main
        case detail(id: String)
        case register
        
        case clothesDetail(id: String)
        case clothesRegister(_ clothes: ClothesEntity)
        
        public var id: String { "\(self)" }
    }
    
}
