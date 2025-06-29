//
//  DateSelectButton.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//

import SwiftUI

public struct DateSelectButton: View {
    @Binding var selectedDate: Date?
    
    private let title: String
    private let date: Date
    
    private var buttonFillColor: Color {
        selectedDate == nil ? .negguSecondaryAlt : selectedDate == date ? .negguSecondary : .bgInactive
    }
    
    private var buttonTitleColor: Color {
        selectedDate == nil ? .negguSecondary : selectedDate == date ? .labelRNormal : .labelInactive
    }
    
    public init(selectedDate: Binding<Date?>, title: String, date: Date) {
        self._selectedDate = selectedDate
        self.title = title
        self.date = date
    }
    
    public var body: some View {
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
