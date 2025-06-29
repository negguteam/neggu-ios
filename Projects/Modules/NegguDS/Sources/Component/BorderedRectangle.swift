//
//  BorderedRectangle.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

public struct BorderedRectangle: View {
    private let title: String
    private let isSelected: Bool
    
    public init(_ title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    public var body: some View {
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
