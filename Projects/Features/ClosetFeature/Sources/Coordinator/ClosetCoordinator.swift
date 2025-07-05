//
//  ClosetCoordinator.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature
import ClosetFeatureInterface

import SwiftUI
import Combine

public final class ClosetCoordinator: BaseCoordinator {
    
    public weak var rootCoordinator: (any MainCoordinatorable)?
    
    private var bag = Set<AnyCancellable>()
    
    private let closetBuilder: any ClosetFeatureBuildable
    
    public init(closetBuilder: any ClosetFeatureBuildable) {
        self.closetBuilder = closetBuilder
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
        case .clothesMain:
            closetBuilder.makeMain(self)
        case .clothesDetail(let clothesId):
            closetBuilder.makeDetail(self, clothesId)
                .presentationDetents([.fraction(0.9)])
        case .clothesRegister(let entry):
            closetBuilder.makeRegister(self, entry)
            
        case .clothesNameSheet(let name):
            closetBuilder.makeNameSheet(clothesName: name)
                .presentationDetents([.height(270)])
        case .categorySheet(let category, let subCategory):
            closetBuilder.makeCategorySheet(category: category, subCategory: subCategory)
                .presentationDetents([.fraction(0.85)])
        case .moodSheet(let selection, let isSingle):
            closetBuilder.makeMoodSheet(selection: selection, isSingle: isSingle)
                .presentationDetents([.fraction(0.85)])
        case .brandSheet(let selection, let brandList):
            closetBuilder.makeBrandSheet(selection: selection, brandList: brandList)
                .presentationDetents([.fraction(0.85)])
        case .colorSheet(let selection):
            closetBuilder.makeColorSheet(selection: selection)
                .presentationDetents([.fraction(0.85)])
        default:
            EmptyView()
        }
    }
    
}
