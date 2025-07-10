//
//  LookBookFeatureBuilder.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Domain

import BaseFeature
import LookBookFeatureInterface

import SwiftUI

public final class LookBookFeatureBuilder: LookBookFeatureBuildable {
    
    private let lookBookUsecase: LookBookUsecase = DIContainer.shared.resolve(LookBookUsecase.self)
    private let userUsecase: UserUsecase = DIContainer.shared.resolve(UserUsecase.self)
    
    public init() { }
    
    
    public func makeMain(_ router: any LookBookMainRoutable) -> AnyView {
        let viewModel = LookBookMainViewModel(router: router, lookBookUsecase: lookBookUsecase, userUsecase: userUsecase)
        let lookBookMainView = LookBookMainView(viewModel: viewModel)
        return lookBookMainView.eraseToAnyView()
    }
    
    public func makeDetail(_ router: any LookBookDetailRoutable, _ lookBookID: String) -> AnyView {
        let viewModel = LookBookDetailViewModel(router: router, lookBookUsecase: lookBookUsecase)
        let lookBookDetailView = LookBookDetailView(viewModel: viewModel, lookBookID: lookBookID)
        return lookBookDetailView.eraseToAnyView()
    }
    
    public func makeRegister(_ router: any LookBookRegisterRoutable) -> AnyView {
        let viewModel = LookBookRegisterViewModel(router: router, lookBookUsecase: lookBookUsecase)
        let lookBookRegisterView = LookBookRegisterView(viewModel: viewModel)
        return lookBookRegisterView.eraseToAnyView()
    }
    
    public func makeSetting(_ router: any SettingRoutable) -> AnyView {
        guard let router = router as? SettingRouter else { return EmptyView().eraseToAnyView() }
        let view = SettingView(router: router, usecase: userUsecase)
        return view.eraseToAnyView()
    }
    
    public func makePolicy(_ router: any PolicyRoutable, policyType: PolicyType) -> AnyView {
        guard let router = router as? PolicyRouter else { return EmptyView().eraseToAnyView() }
        let view = PolicyView(router: router, policyType)
        return view.eraseToAnyView()
    }
    
}
