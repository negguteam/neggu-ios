//
//  LookBookFeatureBuildable.swift
//  LookBookFeatureInterface
//

import BaseFeature

import SwiftUI

public protocol LookBookFeatureBuildable {
    func makeMain() -> AnyView
    func makeDetail(_ lookBookID: String) -> AnyView
    func makeRegister(_ coordinator: BaseCoordinator) -> AnyView
}
