//
//  ClothesRegisterViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/18/25.
//

import Core
import Networks

import BaseFeature
import ClosetFeatureInterface

import Foundation
import Combine

public final class ClothesRegisterViewModel: ObservableObject {
    
    // MARK: Input
    let colorDidConfigure = PassthroughSubject<ColorFilter, Never>()
    
    let nameDidEdit = PassthroughSubject<String, Never>()
    let linkDidEdit = PassthroughSubject<String, Never>()
    let memoDidEdit = PassthroughSubject<String, Never>()
    
    let categoryDidSelect = PassthroughSubject<Core.Category, Never>()
    let subCategoryDidSelect = PassthroughSubject<Core.SubCategory, Never>()
    let moodDidSelect = PassthroughSubject<[Core.Mood], Never>()
    let brandDidSelect = PassthroughSubject<String, Never>()
    let priceRangeDidSelect = PassthroughSubject<Core.PriceRange, Never>()
    let purchaseStateDidSelect = PassthroughSubject<Bool, Never>()
    
    let registerButtonDidTap = PassthroughSubject<Data, Never>()
    let modifyButtonDidTap = PassthroughSubject<ClothesEntity, Never>()
    
    // MARK: Output
    @Published private(set) var registerClothes: ClothesRegisterEntity = .emptyData
    
    @Published private(set) var clothesColorName: String = ""
    @Published private(set) var brandList: [BrandEntity] = []
    @Published private(set) var isValidCategory: Bool = true
    @Published private(set) var isValidMood: Bool = true
    @Published private(set) var registState: RegistState = .idle
    
    var joinedClothesName: String {
        if registerClothes.name.isEmpty {
            [clothesColorName, registerClothes.brand,
             registerClothes.subCategory == .UNKNOWN ? registerClothes.category.title : registerClothes.subCategory.title]
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        } else {
            registerClothes.name
        }
    }
    
    var categoryString: String {
        if registerClothes.subCategory != .UNKNOWN {
            [registerClothes.category.title, registerClothes.subCategory.title].joined(separator: " > ")
        } else if registerClothes.category != .UNKNOWN {
            registerClothes.category.title
        } else {
            "옷의 종류"
        }
    }
    
    var moodString: String {
        registerClothes.mood.isEmpty ? "옷의 분위기" : registerClothes.mood.map { $0.title }.joined(separator: ", ")
    }
    
    var brandString: String {
        registerClothes.brand.isEmpty ? "브랜드" : registerClothes.brand
    }
    
    private var bag = Set<AnyCancellable>()
    
    private let closetUsecase: any ClosetUsecase
    
    public init(closetUsecase: any ClosetUsecase) {
        self.closetUsecase = closetUsecase
        
        bind()
        print("\(self) init")
    }
    
    deinit {
        bag.removeAll()
        print("\(self) deinit")
    }
    
    
    private func bind() {
        nameDidEdit
            .assign(to: \.registerClothes.name, on: self)
            .store(in: &bag)
        
        categoryDidSelect
            .withUnretained(self)
            .sink { owner, category in
                owner.isValidCategory = true
                owner.registerClothes.category = category
            }.store(in: &bag)
            
        subCategoryDidSelect
            .assign(to: \.registerClothes.subCategory, on: self)
            .store(in: &bag)
        
        moodDidSelect
            .withUnretained(self)
            .sink { owner, mood in
                owner.isValidMood = true
                owner.registerClothes.mood = mood
            }.store(in: &bag)
        
        brandDidSelect
            .receive(on: RunLoop.main)
            .assign(to: \.registerClothes.brand, on: self)
            .store(in: &bag)
        
        priceRangeDidSelect
            .assign(to: \.registerClothes.priceRange, on: self)
            .store(in: &bag)
        
        purchaseStateDidSelect
            .assign(to: \.registerClothes.isPurchase, on: self)
            .store(in: &bag)
        
        linkDidEdit
            .assign(to: \.registerClothes.link, on: self)
            .store(in: &bag)
        
        memoDidEdit
            .assign(to: \.registerClothes.memo, on: self)
            .store(in: &bag)
        
        colorDidConfigure
            .withUnretained(self)
            .sink { owner, color in
                owner.clothesColorName = color.title
                owner.registerClothes.colorCode = color.hexCode
            }.store(in: &bag)
        
        registerButtonDidTap
            .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, imageData in
                guard owner.validateField() else { return }
                owner.registerClothes.name = owner.joinedClothesName
                
                owner.closetUsecase.registerClothes(image: imageData, request: owner.registerClothes)
            }.store(in: &bag)
        
        modifyButtonDidTap
            .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, clothes in
                guard owner.validateField() else { return }
                owner.registerClothes.name = owner.joinedClothesName
                
                let request = owner.registerClothes.toClothesEntity(
                    id: clothes.id,
                    accountId: clothes.accountId,
                    imageUrl: clothes.imageUrl
                )
                
                owner.closetUsecase.modifyClothes(request)
            }.store(in: &bag)
        
        closetUsecase.registeredClothes
            .withUnretained(self)
            .sink { owner, clothes in
                owner.registState = clothes != nil ? .success : .failure
            }.store(in: &bag)
        
        closetUsecase.brandList
            .receive(on: RunLoop.main)
            .assign(to: \.brandList, on: self)
            .store(in: &bag)
    }
    
    private func validateField() -> Bool {
        if registerClothes.category != .UNKNOWN && !registerClothes.mood.isEmpty {
            return true
        } else {
            if registerClothes.category == .UNKNOWN {
                isValidCategory = false
            }
            
            if registerClothes.mood.isEmpty {
                isValidMood = false
            }
        
            return false
        }
    }
    
    enum RegistState: Equatable {
        case idle
        case success
        case failure
    }
    
}

fileprivate extension ClothesRegisterEntity {
    
    func toClothesEntity(id: String, accountId: String, imageUrl: String) -> ClothesEntity {
        return .init(
            id: id,
            accountId: accountId,
            clothId: id,
            name: self.name,
            link: self.link,
            imageUrl: imageUrl,
            category: self.category,
            subCategory: self.subCategory,
            mood: self.mood,
            brand: self.brand,
            priceRange: self.priceRange,
            memo: self.memo,
            color: "",
            colorCode: self.colorCode ?? "",
            isPurchase: self.isPurchase,
            modifiedAt: ""
        )
    }
    
}
