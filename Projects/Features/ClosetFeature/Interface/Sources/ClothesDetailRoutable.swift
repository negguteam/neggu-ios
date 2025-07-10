//
//  ClothesDetailRoutable.swift
//  ClosetFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Domain

import BaseFeature

public protocol ClothesDetailRoutable: Routable {
    func presentModify(_ clothes: ClothesEntity)
    func dismiss()
}
