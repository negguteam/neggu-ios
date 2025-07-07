//
//  BorderedChip.swift
//  neggu
//
//  Created by 유지호 on 11/18/24.
//

import SwiftUI

public struct BorderedChip: View {
    private let title: String
    private let isSelected: Bool
    
    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Text(title)
            .negguFont(.body3b)
            .foregroundStyle(isSelected ? .negguSecondary : .labelAlt)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background {
                Capsule()
                    .fill(isSelected ? .negguSecondaryAlt : .clear)
                    .strokeBorder(isSelected ? .negguSecondary : .lineNormal)
            }
    }
}
