//
//  LookBook.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import Foundation

struct LookBook: Equatable, Hashable {
    
}

struct NegguClothes: Equatable, Hashable {
    let id: String
    var account: String
    var imageURL: String
    var category: String
    var subCategory: String
    var mood: String
    var brand: String
    var sku: String
    var priceRange: String
    var memo: String
    var isPurchase: Bool
    var colorCode: String
}
