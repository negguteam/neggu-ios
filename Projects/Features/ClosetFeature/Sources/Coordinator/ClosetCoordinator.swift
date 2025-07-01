//
//  ClosetCoordinator.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Networks

import BaseFeature
import ClosetFeatureInterface

import SwiftUI

public final class ClosetCoordinator: Coordinator {
    
    @Published public var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    public weak var rootCoordinator: (any MainCoordinatorable)?
    
    private let builder: any ClosetFeatureBuildable = ClosetFeatureBuilder()
    
    public init() { }
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .main:
            builder.makeMain()
        case .detail(let clothesId):
            builder.makeDetail(clothesId)
                .presentationDetents([.fraction(0.9)])
        case .register(let entry):
            builder.makeRegister(entry)
        }
    }
    
    public enum Destination: Sceneable {
        case main
        case detail(clothesId: String)
        case register(entry: ClothesEditType)
        
        public var id: String { "\(self)" }
    }
    
}
