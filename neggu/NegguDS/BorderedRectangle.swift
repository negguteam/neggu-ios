//
//  BorderedRectangle.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

struct BorderedRectangle: View {
    let title: String
    let isSelected: Bool
    
    init(_ title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? .negguSecondaryAlt : .labelRAlt)
            .strokeBorder(isSelected ? .negguSecondary : .labelInactive)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .overlay {
                Text(title)
                    .negguFont(.body2)
                    .foregroundStyle(isSelected ? .negguSecondary : .labelInactive)
            }
    }
}
