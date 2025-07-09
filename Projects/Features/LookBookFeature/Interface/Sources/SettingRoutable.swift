//
//  SettingRoutable.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature

public protocol SettingRoutable {
    func routeToPolicy(_ policyType: PolicyType)
    func pop()
    func popToRoot()
}
