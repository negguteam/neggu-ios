//
//  BorderedChip.swift
//  neggu
//
//  Created by 유지호 on 11/18/24.
//

import SwiftUI

struct BorderedChip: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
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
