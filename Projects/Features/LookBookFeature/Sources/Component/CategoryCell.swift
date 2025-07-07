//
//  CategoryCell.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/7/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core
import NegguDS

import SwiftUI

struct CategoryCell: View {
    let category: Core.Category
    let isSelected: Bool
    
    init(_ category: Core.Category, isSelected: Bool) {
        self.category = category
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            icon
                .frame(width: 24, height: 24)
            
            Text(category.title)
                .negguFont(.body2b)
                .padding(.trailing, 4)
        }
        .frame(height: 44)
        .foregroundStyle(isSelected ? .negguSecondary : .labelInactive)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 22)
                .fill(.white)
        }
    }
    
    var icon: Image {
        switch category {
        case .TOP:
            NegguImage.Icon.shirtFill
        case .BOTTOM:
            NegguImage.Icon.pants
        case .OUTER:
            NegguImage.Icon.outer
        case .DRESS:
            NegguImage.Icon.onepiece
        case .ACCESSORY:
            NegguImage.Icon.smallNegguStar.renderingMode(.template)
        case .BAG:
            NegguImage.Icon.smallNegguStar.renderingMode(.template)
        case .SHOES:
            NegguImage.Icon.smallNegguStar.renderingMode(.template)
        default:
            NegguImage.Icon.hanger
        }
    }
}
