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
    let lookBook: LookBookEntity
    
    init(lookBook: LookBookEntity, targetDate: Date) {
        let (dateString, dateColor) = targetDate.generateLookBookDate()
        self.lookBook = lookBook
        self.dateString = dateString
        self.dateColor = dateColor
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .frame(height: 260)
                .overlay {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: lookBook.imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.clear
                                .overlay {
                                    ProgressView()
                                }
                        }
                        
                        if let decorator = lookBook.decorator {
                            AsyncImage(url: URL(string: decorator.imageUrl))
                                .frame(width: 36, height: 36)
                                .clipShape(.circle)
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
