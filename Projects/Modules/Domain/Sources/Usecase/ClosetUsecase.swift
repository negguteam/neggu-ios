//
//  ClosetUsecase.swift
//  Networks
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import Foundation
import Combine

public protocol ClosetUsecase {
    var clothesList: CurrentValueSubject<[ClothesEntity], Never> { get }
    var clothes: PassthroughSubject<ClothesEntity?, Never> { get }
    var registeredClothes: PassthroughSubject<ClothesEntity?, Never> { get }
    var brandList: CurrentValueSubject<[BrandEntity], Never> { get }
    
    func fetchClothesList(parameters: [String: Any])
    func fetchClothesDetail(_ id: String)
    func fetchBrandList()
    func registerClothes(image: Data, request: ClothesRegisterEntity)
    func modifyClothes(_ clothes: ClothesEntity)
    func deleteClothes(_ id: String)
    func resetClothesList()
}

public final class DefaultClosetUsecase: ClosetUsecase {
    
    public let clothesList = CurrentValueSubject<[ClothesEntity], Never>([])
    public let clothes = PassthroughSubject<ClothesEntity?, Never>()
    public let registeredClothes = PassthroughSubject<ClothesEntity?, Never>()
    public let brandList = CurrentValueSubject<[BrandEntity], Never>([])
    
    private var isLoading: Bool = false
    private var page: Int = 0
    
    private let closetService: ClosetService
    
    private var bag = Set<AnyCancellable>()
    
    public init(closetService: ClosetService) {
        self.closetService = closetService
        
        fetchBrandList()
    }
    
    
    public func fetchClothesList(parameters: [String: Any]) {
        if isLoading { return }
        isLoading = true
        
        var parameters = parameters
        parameters["page"] = page
        parameters["size"] = 18
        
        closetService.clothesList(parameters: parameters)
            .withUnretained(self)
            .sink { event in
                print("FetchClothesList:", event)
            } receiveValue: { owner, closet in
                owner.isLoading = closet.last
                owner.page += closet.last ? 0 : 1
                
                var current = owner.clothesList.value
                current += closet.content
                owner.clothesList.send(current)
            }.store(in: &bag)
    }
    
    public func fetchClothesDetail(_ id: String) {
        closetService.clothesDetail(id: id)
            .withUnretained(self)
            .sink { event in
                print("FetchClothesDetail:", event)
            } receiveValue: { owner, clothes in
                owner.clothes.send(clothes)
            }.store(in: &bag)
    }
    
    public func fetchBrandList() {
        closetService.brandList()
            .withUnretained(self)
            .sink { event in
                print("FetchBrandList:", event)
            } receiveValue: { owner, brandList in
                owner.brandList.send(brandList)
            }.store(in: &bag)
    }
    
    public func registerClothes(image: Data, request: ClothesRegisterEntity) {
        closetService.register(image: image, request: request)
            .withUnretained(self)
            .sink { [weak self] event in
                switch event {
                case .finished:
                    print("RegisterClothes:", event)
                case .failure:
                    self?.registeredClothes.send(nil)
                }
            } receiveValue: { owner, clothes in
                owner.registeredClothes.send(clothes)
                owner.resetClothesList()
                owner.fetchClothesList(parameters: [:])
            }.store(in: &bag)
    }
    
    public func modifyClothes(_ clothes: ClothesEntity) {
        closetService.modify(clothes)
            .withUnretained(self)
            .sink { event in
                print("ModifyClothes:", event)
            } receiveValue: { owner, clothes in
                owner.registeredClothes.send(clothes)
            }.store(in: &bag)
    }
    
    public func deleteClothes(_ id: String) {
        closetService.deleteClothes(id: id)
            .withUnretained(self)
            .sink { event in
                print("DeleteClothes:", event)
            } receiveValue: { owner, clothes in
                var current = owner.clothesList.value
                current.removeAll(where: { $0.id == id })
                owner.clothesList.send(current)
            }.store(in: &bag)
    }
    
    public func resetClothesList() {
        page = 0
        isLoading = false
        clothesList.send([])
    }
    
}


public final class MockClosetUsecase: ClosetUsecase {
    
    public let clothesList = CurrentValueSubject<[ClothesEntity], Never>([])
    public let clothes = PassthroughSubject<ClothesEntity?, Never>()
    public let registeredClothes = PassthroughSubject<ClothesEntity?, Never>()
    public let brandList = CurrentValueSubject<[BrandEntity], Never>([])
    
    private var isLoading: Bool = false
    private var page: Int = 0
    
    private var bag = Set<AnyCancellable>()
    
    public init() {
        fetchBrandList()
    }
    
    
    public func fetchClothesList(parameters: [String: Any]) {
        if isLoading { return }
        
        let mockList: [ClothesEntity] = ((page * 18)...((page + 1) * 18 - 1)).map {
            .init(
                id: "\($0)",
                accountId: "\($0)",
                clothId: "\($0)",
                name: "의상\($0)",
                link: "www.neggu.com",
                imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
                category: Category.allCasesArray.randomElement() ?? .TOP,
                subCategory: SubCategory.allCasesArray.randomElement() ?? .T_SHIRT,
                mood: [.MODERN],
                brand: "Neggu",
                priceRange: .UNKNOWN,
                memo: "테스트 메모",
                color: "",
                colorCode: "",
                isPurchase: Bool.random(),
                modifiedAt: Date.now.toISOFormatString()
            )
        }
        
        isLoading = page == 2
        page += 1
        
        var current = clothesList.value
        current += mockList
        clothesList.send(current)
    }
    
    public func fetchClothesDetail(_ id: String) {
        let mock: ClothesEntity = .init(
            id: "\(id)",
            accountId: "\(id)",
            clothId: "\(id)",
            name: "의상\(id)",
            link: "www.neggu.com",
            imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
            category: Category.allCasesArray.randomElement() ?? .TOP,
            subCategory: SubCategory.allCasesArray.randomElement() ?? .T_SHIRT,
            mood: [.MODERN],
            brand: "Neggu",
            priceRange: .UNKNOWN,
            memo: "테스트 메모",
            color: "",
            colorCode: "",
            isPurchase: Bool.random(),
            modifiedAt: Date.now.toISOFormatString()
        )
        
        clothes.send(mock)
    }
    
    public func fetchBrandList() {
        let mockList: [BrandEntity] = (0...9).map {
            .init(id: "\($0)", kr: "브랜드\($0)", en: "Brand\($0)")
        }
        
        print(mockList)
        
        brandList.send(mockList)
    }
    
    public func registerClothes(image: Data, request: ClothesRegisterEntity) {
        let mock: ClothesEntity = .init(
            id: "Success",
            accountId: "Success",
            clothId: "Success",
            name: request.name,
            link: request.link,
            imageUrl: "",
            category: request.category,
            subCategory: request.subCategory,
            mood: request.mood,
            brand: request.brand,
            priceRange: request.priceRange,
            memo: request.memo,
            color: "",
            colorCode: request.colorCode ?? "#FFFFFF",
            isPurchase: request.isPurchase,
            modifiedAt: Date.now.toISOFormatString()
        )
        
        registeredClothes.send(mock)
        resetClothesList()
        fetchClothesList(parameters: [:])
    }
    
    public func modifyClothes(_ clothes: ClothesEntity) {
        registeredClothes.send(clothes)
        resetClothesList()
        fetchClothesList(parameters: [:])
    }
    
    public func deleteClothes(_ id: String) {
        var current = clothesList.value
        current.removeAll(where: { $0.id == id })
        clothesList.send(current)
    }
    
    public func resetClothesList() {
        page = 0
        isLoading = false
        clothesList.send([])
    }
    
}
