//
//  ClosetFeatureBuildable.swift
//  ClosetFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public protocol ClosetFeatureBuildable {
    func makeMain() -> AnyView
    func makeDetail(_ clothesId: String) -> AnyView
    func makeRegister(_ entry: ClothesEditType) -> AnyView
    func makeClothesNameEdit() -> AnyView
}
