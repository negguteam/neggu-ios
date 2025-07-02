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
    var brandList: PassthroughSubject<[BrandEntity], Never> { get }
    
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
    public let brandList = PassthroughSubject<[BrandEntity], Never>()
    
    private var isLoading: Bool = false
    private var page: Int = 0
    
    private let closetService: ClosetService
    
    private var bag = Set<AnyCancellable>()
    
    public init(closetService: ClosetService) {
        self.closetService = closetService
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
