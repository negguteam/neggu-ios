//
//  LookBookFeatureBuilder.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Networks

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

public final class LookBookFeatureBuilder: LookBookFeatureBuildable {
    
    private let lookBookUsecase: LookBookUsecase = DIContainer.shared.resolve(LookBookUsecase.self)
    private let userUsecase: UserUsecase = DIContainer.shared.resolve(UserUsecase.self)
    
    private lazy var mainViewModel = LookBookMainViewModel(lookBookUsecase: lookBookUsecase, userUsecase: userUsecase)
    
    public init() { }
    
    
    public func makeMain() -> AnyView {
        let viewModel = mainViewModel
        let lookBookMainView = LookBookMainView(viewModel: viewModel)
        return lookBookMainView.eraseToAnyView()
    }
    
    public func makeDetail(_ lookBookID: String) -> AnyView {
        let viewModel = LookBookDetailViewModel(lookBookUsecase: lookBookUsecase)
        let lookBookDetailView = LookBookDetailView(viewModel: viewModel, lookBookID: lookBookID)
        return lookBookDetailView.eraseToAnyView()
    }
    
    public func makeRegister(_ coordinator: BaseCoordinator) -> AnyView {
        let viewModel = LookBookRegisterViewModel(lookBookUsecase: lookBookUsecase)
        let lookBookRegisterView = LookBookRegisterView(coordinator: coordinator, viewModel: viewModel)
        return lookBookRegisterView.eraseToAnyView()
    }
    
}
