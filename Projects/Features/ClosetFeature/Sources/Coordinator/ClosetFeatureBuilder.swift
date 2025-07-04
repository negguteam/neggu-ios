//
//  ClosetFeatureBuilder.swift
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


public final class ClosetFeatureBuilder: ClosetFeatureBuildable {
    
    private let closetUsecase: ClosetUsecase = DIContainer.shared.resolve(ClosetUsecase.self)
    
    public init() { }
    
    
    public func makeMain(_ coordinator: BaseCoordinator) -> AnyView {
        let viewModel = ClosetViewModel(closetUsecase: closetUsecase)
        let closetView = ClosetView(coordinator: coordinator, viewModel: viewModel)
        return closetView.eraseToAnyView()
    }
    
    public func makeDetail(_ coordinator: BaseCoordinator, _ clothesID: String) -> AnyView {
        let viewModel = ClothesDetailViewModel(closetUsecase: closetUsecase)
        let clothesDetailView = ClothesDetailView(coordinator: coordinator, viewModel: viewModel, clothesId: clothesID)
        return clothesDetailView.eraseToAnyView()
    }
    
    public func makeRegister(_ coordinator: BaseCoordinator, _ entry: ClothesEditType) -> AnyView {
        let viewModel = ClothesRegisterViewModel(closetUsecase: closetUsecase)
        let clothesRegisterView = ClothesRegisterView(coordinator: coordinator, viewModel: viewModel, entry: entry)
        return clothesRegisterView.eraseToAnyView()
    }
    
    public func makeNameSheet(clothesName: Binding<String>) -> AnyView {
        ClothesNameSheet(clothesName: clothesName)
            .eraseToAnyView()
    }
    
    public func makeCategorySheet(
        category: Binding<Core.Category>,
        subCategory: Binding<Core.SubCategory>
    ) -> AnyView {
        CategorySheet(categorySelection: category, subCategorySelection: subCategory)
            .eraseToAnyView()
    }
    
    public func makeMoodSheet(selection: Binding<[Mood]>, isSingle: Bool) -> AnyView {
        MoodSheet(selection: selection, isSingleSelection: isSingle)
            .eraseToAnyView()
    }
    
    public func makeBrandSheet(selection: Binding<String>, brandList: [BrandEntity]) -> AnyView {
        BrandSheet(selectedBrand: selection, brandList: brandList)
            .eraseToAnyView()
    }
    
    public func makeColorSheet(selection: Binding<ColorFilter?>) -> AnyView {
        ColorSheet(selection: selection)
            .eraseToAnyView()
    }
    
}
