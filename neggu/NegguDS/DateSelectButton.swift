//
//  DateSelectButton.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//

import SwiftUI

struct DateSelectButton: View {
    @Binding var selectedDate: Date?
    
    let title: String
    let date: Date
    
    private var buttonFillColor: Color {
        selectedDate == nil ? .negguSecondaryAlt : selectedDate == date ? .negguSecondary : .bgInactive
    }
    
    private var buttonTitleColor: Color {
        selectedDate == nil ? .negguSecondary : selectedDate == date ? .labelRNormal : .labelInactive
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(buttonFillColor)
            .frame(height: 32)
            .overlay {
                Text(title)
                    .negguFont(.body2b)
                    .foregroundStyle(buttonTitleColor)
            }
    }
}
