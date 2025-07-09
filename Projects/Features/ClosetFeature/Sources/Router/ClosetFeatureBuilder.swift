//
//  ClosetFeatureBuilder.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Domain

import BaseFeature
import ClosetFeatureInterface

import SwiftUI


public final class ClosetFeatureBuilder: ClosetFeatureBuildable {
    
    private let closetUsecase: ClosetUsecase = DIContainer.shared.resolve(ClosetUsecase.self)
    
    public init() { }
    
    
    public func makeMain(_ router: any ClosetRoutable) -> AnyView {
        let viewModel = ClosetViewModel(router: router, closetUsecase: closetUsecase)
        let closetView = ClosetView(viewModel: viewModel)
        return closetView.eraseToAnyView()
    }
    
    public func makeDetail(_ router: any ClothesDetailRoutable, _ clothesID: String) -> AnyView {
        let viewModel = ClothesDetailViewModel(router: router, closetUsecase: closetUsecase)
        let clothesDetailView = ClothesDetailView(viewModel: viewModel, clothesId: clothesID)
        return clothesDetailView.eraseToAnyView()
    }
    
    public func makeRegister(_ router: any ClothesRegisterRoutable, _ entry: ClothesEditType) -> AnyView {
        let viewModel = ClothesRegisterViewModel(router: router, closetUsecase: closetUsecase)
        let clothesRegisterView = ClothesRegisterView(viewModel: viewModel, entry: entry)
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
    
    public func makeDetailRouter(rootRouter: any Coordinatable, builder: any ClosetFeatureBuildable, id: String) -> any ClothesDetailRoutable {
        let router = ClothesDetailRouter(
            rootRouter: rootRouter,
            closetBuilder: builder,
            clothesID: id
        )
        return router
    }
    
}
