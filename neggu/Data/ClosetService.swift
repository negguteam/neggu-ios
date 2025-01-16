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
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error>
    func clothesList(page: Int, size: Int) -> AnyPublisher<ClosetEntity, Error>
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
        print(image.base64EncodedString(), String(data: object, encoding: .utf8))
        return requestObjectWithNetworkError(.register(
            image: image,
            request: object
        ))
    }
    
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.clothesDetail(id: id))
    }
    
    func clothesList(page: Int, size: Int) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.clothesList(page: page, size: size))
    }
    
    func brandList() -> AnyPublisher<[BrandEntity], Error> {
        requestObjectWithNetworkError(.brandList)
    }
    
    func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error> {
        requestObjectWithNetworkError(.deleteClothes(id: id))
    }
    
}
