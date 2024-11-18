//
//  ToggleButtonPicker.swift
//  neggu
//
//  Created by 유지호 on 11/18/24.
//

import SwiftUI

protocol Selectable: CaseIterable, Hashable {
    var title: String { get }
    static var allCasesArray: [Self] { get }
}

extension Selectable {
    static var allCasesArray: [Self] {
        Array(allCases)
    }
}

struct ToggleButtonPicker<S: Selectable>: View {
    @Binding var selection: S?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(S.allCasesArray, id: \.self) { select in
                    let isSelected = selection == select
                    
                    Text(select.title)
                        .negguFont(.body3b)
                        .foregroundStyle(isSelected ? .negguSecondary : .labelAlt)
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background {
                            Capsule()
                                .fill(isSelected ? .negguSecondaryAlt : .clear)
                                .strokeBorder(isSelected ? .negguSecondary : .lineNormal)
                        }
                        .onTapGesture {
                            if isSelected {
                                selection = nil
                            } else {
                                selection = select
                            }
                        }
                }
            }
            .padding(.horizontal, 28)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, -28)
    }
}
