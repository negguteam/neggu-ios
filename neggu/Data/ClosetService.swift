//
//  ClosetService.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Foundation
import Combine

typealias DefaultClosetService = BaseService<ClosetAPI>

protocol ClosetService {
    func register(image: Data, request: ClothesRegisterEntity) -> AnyPublisher<ClothesEntity, Error>
    func modify(_ clothes: ClothesEntity) -> AnyPublisher<ClothesEntity, Error>
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error>
    func clothesList(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func brandList() -> AnyPublisher<[BrandEntity], Error>
    func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error>
}

extension DefaultClosetService: ClosetService {
    
    func register(image: Data, request: ClothesRegisterEntity) -> AnyPublisher<ClothesEntity, Error> {
        let dictionary: [String: Any] = [
            "name": request.name,
            "colorCode": request.colorCode ?? "#FFFFFF",
            "category": request.category.id,
            "subCategory": request.subCategory.id,
            "mood": request.mood.map { $0.id },
            "brand": request.brand,
            "priceRange": request.priceRange.id,
            "memo": request.memo,
            "isPurchase": request.isPurchase,
            "link": request.link
        ]
        let object = (try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)) ?? .init()
        return requestObjectWithNetworkError(.register(
            image: image,
            request: object
        ))
    }
    
    func modify(_ clothes: ClothesEntity) -> AnyPublisher<ClothesEntity, Error> {
        var parameters: [String: Any] = [
            "id": clothes.id,
            "accountId": clothes.accountId,
            "imageUrl": clothes.imageUrl,
            "colorCode": clothes.colorCode,
            "name": clothes.name,
            "category": clothes.category,
            "subCategory": clothes.subCategory,
            "mood": clothes.mood,
            "priceRange": clothes.priceRange,
            "memo": clothes.memo,
            "isPurchase": clothes.isPurchase
        ]
        
        if !clothes.brand.isEmpty {
            parameters["brand"] = clothes.brand
        }
        
        if !clothes.link.isEmpty {
            parameters["link"] = clothes.link
        }
        
        return requestObjectWithNetworkError(.modify(paramters: parameters))
    }
    
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.clothesDetail(id: id))
    }
    
    func clothesList(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.clothesList(parameters: parameters))
    }
    
    func brandList() -> AnyPublisher<[BrandEntity], Error> {
        requestObjectWithNetworkError(.brandList)
    }
    
    func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.deleteClothes(id: id))
    }
    
}
