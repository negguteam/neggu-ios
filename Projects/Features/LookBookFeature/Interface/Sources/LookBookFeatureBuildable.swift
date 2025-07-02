//
//  LookBookFeatureBuildable.swift
//  LookBookFeatureInterface
//

import SwiftUI

public protocol LookBookFeatureBuildable {
    func makeMain() -> AnyView
    func makeDetail(_ lookBookID: String) -> AnyView
    func makeRegister() -> AnyView
}
