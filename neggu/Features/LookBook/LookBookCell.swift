//
//  LookBookCell.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//

import SwiftUI

struct LookBookCell: View {
    let dateString: String
    let dateColor: Color
    let isNeggu: Bool
    
    init(dateString: String, dateColor: Color, isNeggu: Bool = false) {
        self.dateString = dateString
        self.dateColor = dateColor
        self.isNeggu = isNeggu
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(height: 260)
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        Image(.dummyLookbook)
                            .resizable()
                            .scaledToFit()
                        
                        if isNeggu {
                            Circle()
                                .frame(width: 36, height: 36)
                        }
                    }
                    .padding(10)
                }
            
            HStack(spacing: 4) {
                Image(systemName: "alarm")
                
                Text(dateString)
            }
            .negguFont(.caption)
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .frame(height: 24)
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: 8,
                    bottomLeadingRadius: 8,
                    topTrailingRadius: 8
                )
                .fill(dateColor)
            }
        }
    }
}
