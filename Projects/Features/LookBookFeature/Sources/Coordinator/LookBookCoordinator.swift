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
//        case .lookBookRegister:
//            lookBookBuilder.makeRegister(self)
            
        case .clothesDetail(let clothesID):
            closetBuilder.makeDetail(self, clothesID)
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
            
        case .setting:
            SettingView()
        case .policy(let policyType):
            PolicyView(policyType)
        default:
            EmptyView()
        }
    }
    
}
