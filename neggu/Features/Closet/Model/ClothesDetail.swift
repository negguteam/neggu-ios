//
//  ClothesDetail.swift
//  neggu
//
//  Created by 유지호 on 4/18/25.
//

extension ClothesEntity {
    
    var categoryString: String {
        [category.title, subCategory.title].joined(separator: " > ")
    }
    
    var moodString: String {
        if self.mood.isEmpty {
            "옷의 분위기"
        } else {
            self.mood.map { $0.title }.joined(separator: ", ")
        }
    }
}
