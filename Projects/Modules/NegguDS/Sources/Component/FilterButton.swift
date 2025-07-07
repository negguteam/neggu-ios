//
//  FilterButton.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//


import SwiftUI

public struct FilterButton: View {
    private let title: String
    private let buttonAction: () -> Void
    
    private var isFiltered: Bool {
        title != "카테고리" && title != "분위기" && title != "색상"
    }
    
    public init(title: String, buttonAction: @escaping () -> Void) {
        self.title = title
        self.buttonAction = buttonAction
    }
    
    public var body: some View {
        Button {
            buttonAction()
        } label: {
            HStack(spacing: 4) {
                Text(title)
                    .negguFont(.body2b)
                    .lineLimit(1)
                
                Image(systemName: "chevron.down")
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(isFiltered ? .white : .labelAssistive)
            .frame(height: 35)
            .padding(.leading, 12)
            .padding(.trailing, 8)
            .background {
                RoundedRectangle(cornerRadius: 100)
                    .fill(isFiltered ? .black : .bgAlt)
            }
        }
    }
}
