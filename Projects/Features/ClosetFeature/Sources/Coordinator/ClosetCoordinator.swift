//
//  ClosetCoordinator.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
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
            
        case .clothesNameSheet(let name):
            ClothesNameSheet(clothesName: name)
                .presentationDetents([.height(270)])
        case .categorySheet(let category, let subCategory):
            CategorySheet(categorySelection: category, subCategorySelection: subCategory)
                .presentationDetents([.fraction(0.85)])
        case .moodSheet(let selection, let isSingle):
            MoodSheet(selection: selection, isSingleSelection: isSingle)
                .presentationDetents([.fraction(0.85)])
        case .brandSheet(let selection, let brandList):
            BrandSheet(selectedBrand: selection, brandList: brandList)
                .presentationDetents([.fraction(0.85)])
        case .colorSheet(let selection):
            ColorSheet(selection: selection)
                .presentationDetents([.fraction(0.85)])
        }
    }
    
    public enum Destination: Sceneable {
        case main
        case detail(clothesId: String)
        case register(entry: ClothesEditType)
        
        case clothesNameSheet(name: Binding<String>)
        case categorySheet(category: Binding<Core.Category>, subCategory: Binding<Core.SubCategory>)
        case moodSheet(selection: Binding<[Mood]>, isSingleSelection: Bool = false)
        case brandSheet(selection: Binding<String>, brandList: [BrandEntity])
        case colorSheet(selection: Binding<ColorFilter?>)
        
        public var id: String { "\(self)" }
        
        public static func == (lhs: Destination, rhs: Destination) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
    
}
