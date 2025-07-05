//
//  LookBookCell.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//

import NegguDS
import Domain

import SwiftUI

struct LookBookCell: View {
    private let lookBook: LookBookEntity
    private let targetDate: Date?
    
    init(lookBook: LookBookEntity) {
        self.lookBook = lookBook
        self.targetDate = lookBook.decorator?.targetDate.toISOFormatDate()
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .aspectRatio(3/4, contentMode: .fit)
            .overlay {
//                CachedAsyncImage(lookBook.imageUrl)
                AsyncImage(url: URL(string: lookBook.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    SkeletonView()
                }
                .padding(10)
            }
//            .overlay(alignment: .bottomLeading) {
//                if let decorator = lookBook.decorator {
//                    Group {
//                        if let decoratorImage = decorator.imageUrl {
//                            CachedAsyncImage(decoratorImage)
//                        } else {
//                            Color.black
//                        }
//                    }
//                    .frame(width: 36, height: 36)
//                    .clipShape(.circle)
//                    .padding(10)
//                }
//            }
//            .overlay(alignment: .topTrailing) {
//                if let (dateString, dateColor) = targetDate?.generateLookBookDate() {
//                    HStack(spacing: 4) {
//                        Image(systemName: "alarm")
//                        
//                        Text(dateString)
//                    }
//                    .negguFont(.caption)
//                    .foregroundStyle(.white)
//                    .padding(.horizontal, 12)
//                    .frame(height: 24)
//                    .background {
//                        UnevenRoundedRectangle(
//                            topLeadingRadius: 8,
//                            bottomLeadingRadius: 8,
//                            topTrailingRadius: 8
//                        )
//                        .fill(dateColor)
//                    }
//                }
//            }
    }
}
