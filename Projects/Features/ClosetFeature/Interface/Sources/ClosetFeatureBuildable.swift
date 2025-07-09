//
//  ClosetFeatureBuildable.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import Domain

import BaseFeature

import SwiftUI

public protocol ClosetFeatureBuildable {
    func makeMain(_ router: any ClosetRoutable) -> AnyView
    func makeDetail(_ router: any ClothesDetailRoutable, _ clothesID: String) -> AnyView
    func makeRegister(_ coordinator: any ClothesRegisterRoutable, _ entry: ClothesEditType) -> AnyView
    
    func makeNameSheet(clothesName: Binding<String>) -> AnyView
    func makeCategorySheet(category: Binding<Core.Category>, subCategory: Binding<Core.SubCategory>) -> AnyView
    func makeMoodSheet(selection: Binding<[Mood]>, isSingle: Bool) -> AnyView
    func makeBrandSheet(selection: Binding<String>, brandList: [BrandEntity]) -> AnyView
    
    func makeDetailRouter(rootRouter: any Coordinatable, builder: any ClosetFeatureBuildable, id: String) -> any ClothesDetailRoutable
}
