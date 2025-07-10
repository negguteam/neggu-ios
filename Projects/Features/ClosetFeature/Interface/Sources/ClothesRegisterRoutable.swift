//
//  ClothesRegisterRoutable.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature

public protocol ClothesRegisterRoutable: Routable {
    func presentDetail(id: String)
    func dismiss()
}
