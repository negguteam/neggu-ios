//
//  ListEmptyView.swift
//  neggu
//
//  Created by 유지호 on 4/21/25.
//

import SwiftUI

public struct ListEmptyView: View {
    private let title: String
    private let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .negguFont(.title4)
            
            Text(description)
                .negguFont(.body1b)
        }
        .foregroundStyle(.labelInactive)
        .frame(maxWidth: .infinity)
    }
}
