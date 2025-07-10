//
//  AuthFeatureBuildable.swift
//  AuthFeature
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public protocol AuthFeatureBuildable {
    func makeOnboarding() -> AnyView
    func makeLogin(router: any AuthRoutable) -> AnyView
    func makeSignUp(router: any SignUpRoutable) -> AnyView
    func makeSignUpComplete(router: any SignUpCompleteRoutable) -> AnyView
}
