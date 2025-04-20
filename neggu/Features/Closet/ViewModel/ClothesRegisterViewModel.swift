//
//  ClothesRegisterViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/18/25.
//

import Foundation
import Combine

final class ClothesRegisterViewModel: ObservableObject {
    
    private let closetService: any ClosetService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var bag = Set<AnyCancellable>()
    
    var name: String {
        if output.clothes.name.isEmpty {
            [output.clothes.brand,
//             (clothes.colorCode ?? "").uppercased(),
             output.clothes.subCategory == .UNKNOWN ? output.clothes.category.title : output.clothes.subCategory.title]
                .filter { !$0.isEmpty }.joined(separator: " ")
        } else {
            output.clothes.name
        }
    }
    
    var categoryString: String {
        if output.clothes.subCategory != .UNKNOWN {
            [output.clothes.category.title, output.clothes.subCategory.title].joined(separator: " > ")
        } else if output.clothes.category != .UNKNOWN {
            output.clothes.category.title
        } else {
            "옷의 종류"
        }
    }
    
    var moodString: String {
        if output.clothes.mood.isEmpty {
            "옷의 분위기"
        } else {
            output.clothes.mood.map { $0.title }.joined(separator: ", ")
        }
    }
    
    var brandString: String {
        output.clothes.brand.isEmpty ? "브랜드" : output.clothes.brand
    }
    
    
    init(closetService: any ClosetService) {
        self.closetService = closetService
        
        input
            .sink { self.transform(from: $0) }
            .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    
    func send(action: Action) {
        input.send(action)
    }
    
    private func transform(from action: Action) {
        switch action {
        case .initial(let clothes):
            output.clothes = clothes
        case .editColor(let colorCode):
            output.clothes.colorCode = colorCode
        case .editName(let string):
            output.clothes.name = string
        case .editCategory(let category):
            if output.isUnknownedCategory {
                output.isUnknownedCategory = false
            }
            
            output.clothes.category = category
            
        case .editSubCategory(let subCategory):
            output.clothes.subCategory = subCategory
        case .editMood(let mood):
            if output.isUnknownedMood {
                output.isUnknownedMood = false
            }
            
            output.clothes.mood = mood
        case .editBrand(let brand):
            output.clothes.brand = brand
        case .editPrice(let priceRange):
            output.clothes.priceRange = priceRange
        case .editPurchase(let isPurchase):
            output.clothes.isPurchase = isPurchase
        case .editLink(let link):
            output.clothes.link = link
        case .editMemo(let memo):
            output.clothes.memo = memo
        case .validateCategory(let isValid):
            output.isUnknownedCategory = !isValid
        case .validateMood(let isValid):
            output.isUnknownedMood = !isValid
        case .onTapRegister(let imageData, let clothes, let completion):
            registerClothes(imageData: imageData, clothes: clothes, completion: completion)
        }
    }
    
    private func registerClothes(
        imageData: Data,
        clothes: ClothesRegisterEntity,
        completion: @escaping () -> Void
    ) {
        output.canRegister = false
        output.clothes.name = name
        
        closetService.register(
            image: imageData,
            request: clothes
        ).sink { event in
            completion()
            self.output.canRegister = true
            print("ClosetAdd:", event)
        } receiveValue: { _ in
            
        }.store(in: &bag)
    }
    
}


extension ClothesRegisterViewModel {
    
    struct State {
        var clothes: ClothesRegisterEntity = .emptyData
        var isUnknownedCategory: Bool = false
        var isUnknownedMood: Bool = false
        var canRegister: Bool = true
    }
    
    enum Action {
        case initial(ClothesRegisterEntity)
        case editColor(String)
        case editName(String)
        case editCategory(Category)
        case editSubCategory(SubCategory)
        case editMood([Mood])
        case editBrand(String)
        case editPrice(PriceRange)
        case editPurchase(Bool)
        case editLink(String)
        case editMemo(String)
        case validateCategory(Bool)
        case validateMood(Bool)
        case onTapRegister(Data, ClothesRegisterEntity, () -> Void)
    }
    
}
