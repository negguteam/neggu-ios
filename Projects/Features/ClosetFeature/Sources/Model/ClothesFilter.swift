//
//  ClothesFilter.swift
//  neggu
//
//  Created by 유지호 on 4/17/25.
//

import Core

import BaseFeature

struct ClothesFilter: Equatable {
    var category: Core.Category = .UNKNOWN
    var subCategory: SubCategory = .UNKNOWN
    var moodList: [Mood] = []
    
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
    
    mutating func reset() {
        category = .UNKNOWN
        subCategory = .UNKNOWN
        moodList.removeAll()
    }
}
