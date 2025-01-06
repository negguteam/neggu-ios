//
//  ExpendableTextView.swift
//  neggu
//
//  Created by 유지호 on 12/24/24.
//

import SwiftUI

struct ExpendableTextView: View {
    let placeholder: String
    
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self._text = text
        self.placeholder = placeholder
    }
    
    var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder).foregroundStyle(.labelInactive),
            axis: .vertical
        )
        .negguFont(.body2)
        .frame(minHeight: 48, alignment: .top)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(.lineAlt)
        }
    }
}
