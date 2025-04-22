//
//  ListEmptyView.swift
//  neggu
//
//  Created by 유지호 on 4/21/25.
//

import SwiftUI

struct ListEmptyView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 80) {
            Color.gray10
                .frame(width: 165, height: 165)
                .mask {
                    Image(.negguStarBig)
                }
                .overlay(alignment: .bottomTrailing) {
                    Circle()
                        .fill(.gray20)
                        .frame(width: 46)
                        .offset(x: 8, y: 12)
                }
            
            VStack(spacing: 12) {
                Text(title)
                    .negguFont(.title4)
                
                Text(description)
                    .negguFont(.body1b)
            }
            .foregroundStyle(.labelInactive)
        }
        .frame(maxWidth: .infinity)
    }
}
