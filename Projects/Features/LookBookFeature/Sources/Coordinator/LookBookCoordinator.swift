//
//  LookBookCoordinator.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
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
    
    private let builder = LookBookFeatureBuilder()
    
    public init() { }
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .main:
            builder.makeMain()
        case .detail(let id):
            builder.makeDetail(id)
        case .register:
            builder.makeRegister()
        }
    }
    
    public enum Destination: Sceneable {
        case main
        case detail(id: String)
        case register
        
        public var id: String { "\(self)" }
    }
    
}
