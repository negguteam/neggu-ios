//
//  ClosetService.swift
//  neggu
//
//  Created by 유지호 on 1/16/25.
//

import Domain

import Foundation
import Combine

public typealias DefaultClosetService = BaseService<ClosetAPI>

extension DefaultClosetService: ClosetService {
    
    public func register(image: Data, request: ClothesRegisterEntity) -> AnyPublisher<ClothesEntity, Error> {
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
    
    public func modify(_ clothes: ClothesEntity) -> AnyPublisher<ClothesEntity, Error> {
        var parameters: [String: Any] = [
            "id": clothes.id,
            "accountId": clothes.accountId,
            "imageUrl": clothes.imageUrl,
            "colorCode": clothes.colorCode,
            "name": clothes.name,
            "category": clothes.category.id,
            "subCategory": clothes.subCategory.id,
            "mood": clothes.mood.map { $0.id },
            "priceRange": clothes.priceRange.id,
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
    
    public func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.clothesDetail(id: id))
    }
    
    public func clothesList(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.clothesList(parameters: parameters))
    }
    
    public func clothesInviteList(parameters: [String : Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.clothesInviteList(parameters: parameters))
    }
    
    public func brandList() -> AnyPublisher<[BrandEntity], Error> {
        requestObjectWithNetworkError(.brandList)
    }
    
    public func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.deleteClothes(id: id))
    }
    
}
