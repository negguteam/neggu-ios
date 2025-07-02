//
//  ClosetFeatureBuilder.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Networks

import ClosetFeatureInterface

import SwiftUI


public final class ClosetFeatureBuilder: ClosetFeatureBuildable {
    
    private let closetUsecase: ClosetUsecase = DIContainer.shared.resolve(ClosetUsecase.self)
    
    public init() {
        closetUsecase.fetchBrandList()
    }
    
    
    public func makeMain() -> AnyView {
        let viewModel = ClosetViewModel(closetUsecase: closetUsecase)
        let closetView = ClosetView(viewModel: viewModel)
        return closetView.eraseToAnyView()
    }
    
    public func makeDetail(_ clothesId: String) -> AnyView {
        let viewModel = ClothesDetailViewModel(closetUsecase: closetUsecase)
        let clothesDetailView = ClothesDetailView(viewModel: viewModel, clothesId: clothesId)
        return clothesDetailView.eraseToAnyView()
    }
    
    public func makeRegister(_ entry: ClothesEditType) -> AnyView {
        let viewModel = ClothesRegisterViewModel(closetUsecase: closetUsecase)
        let clothesRegisterView = ClothesRegisterView(viewModel: viewModel, entry: entry)
        return clothesRegisterView.eraseToAnyView()
    }
    
    public func makeClothesNameEdit() -> AnyView {
        VStack { }.eraseToAnyView()
    }
    
}
