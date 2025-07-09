//
//  LookBookFeatureBuildable.swift
//  LookBookFeatureInterface
//

import BaseFeature

import SwiftUI

public protocol LookBookFeatureBuildable {
    func makeMain(_ router: any LookBookMainRoutable) -> AnyView
    func makeDetail(_ router: any LookBookDetailRoutable, _ lookBookID: String) -> AnyView
    func makeRegister(_ router: any LookBookRegisterRoutable) -> AnyView
    func makeSetting(_ router: any SettingRoutable) -> AnyView
    func makePolicy(_ router: any PolicyRoutable, policyType: PolicyType) -> AnyView
}
