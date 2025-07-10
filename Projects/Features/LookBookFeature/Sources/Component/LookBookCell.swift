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
    
    init(lookBook: LookBookEntity) {
        self.lookBook = lookBook
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
    }
}
