//
//  NegguTab.swift
//  BaseFeature
//
//  Created by 유지호 on 6/29/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import NegguDS

import SwiftUI

public enum NegguTab: CaseIterable, Identifiable {
    case closet
    case lookbook
    
    public var activeIcon: Image {
        switch self {
        case .closet: NegguDSAsset.Assets.shirtFill.swiftUIImage
        case .lookbook: NegguDSAsset.Assets.closetFill.swiftUIImage
        }
    }
    
    public var inactiveIcon: Image {
        switch self {
        case .closet: NegguDSAsset.Assets.shirt.swiftUIImage
        case .lookbook: NegguDSAsset.Assets.closet.swiftUIImage
        }
    }
    
    public var id: String { "\(self)" }
}
