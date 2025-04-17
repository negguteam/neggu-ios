//
//  ClothesDetail.swift
//  neggu
//
//  Created by 유지호 on 4/18/25.
//


struct ClothesDetail {
    let id: String
    let name: String
    let imageUrl: String
    let category: Category
    let subCategory: SubCategory
    let moodList: [Mood]
    let brand: String
    let priceRange: PriceRange
    let link: String
    let memo: String
    let colorCode: String
    let color: String
    
    init(entity: ClothesEntity) {
        self.id = entity.id
        self.name = entity.name
        self.imageUrl = entity.imageUrl
        self.category = entity.category
        self.subCategory = entity.subCategory
        self.moodList = entity.mood
        self.brand = entity.brand
        self.priceRange = entity.priceRange
        self.link = entity.link
        self.memo = entity.memo
        self.colorCode = entity.colorCode
        self.color = entity.color
    }
    
    var categoryString: String {
        [category.title, subCategory.title].joined(separator: " > ")
    }
    
    var moodString: String {
        if moodList.isEmpty {
            "옷의 분위기"
        } else {
            moodList.map { $0.title }.joined(separator: ", ")
        }
    }
}
