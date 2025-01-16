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
    func register(image: Data, parameters: [String: Any]) -> AnyPublisher<Data, Error>
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error>
    func clothesList(page: Int, size: Int) -> AnyPublisher<ClosetEntity, Error>
    func brandList() -> AnyPublisher<[BrandEntity], Error>
    func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error>
}

extension DefaultClosetService: ClosetService {
    
    func register(image: Data, parameters: [String : Any]) -> AnyPublisher<Data, Error> {
        requestObjectWithNetworkError(.register(
            image: image,
            parameters: parameters
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
