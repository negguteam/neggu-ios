//
//  ClothesFilter.swift
//  neggu
//
//  Created by 유지호 on 4/17/25.
//

import Foundation

struct ClothesFilter: Equatable {
    var category: Category = .UNKNOWN
    var subCategory: SubCategory = .UNKNOWN
    var moodList: [Mood] = []
    var color: ColorFilter?
    
    var categoryTitle: String {
        if subCategory != .UNKNOWN {
            subCategory.title
        } else if category != .UNKNOWN {
            category.title
        } else {
            "카테고리"
        }
    }
    
    var moodTitle: String {
        if let mood = moodList.first {
            mood.title
        } else {
            "분위기"
        }
    }
    
    var colorTitle: String {
        color?.title ?? "색상"
    }
    
    mutating func reset() {
        category = .UNKNOWN
        subCategory = .UNKNOWN
        moodList.removeAll()
        color = nil
    }
}
