//
//  LookBookService.swift
//  neggu
//
//  Created by 유지호 on 2/14/25.
//

import Foundation
import Combine

typealias DefaultLookBookService = BaseService<LookBookAPI>

protocol LookBookService {
    func register(image: Data, request: [LookBookClothesEntity]) -> AnyPublisher<LookBookEntity, Error>
    func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error>
    func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookEntity, Error>
    func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error>
}

extension DefaultLookBookService: LookBookService {
    
    func register(image: Data, request: [LookBookClothesEntity]) -> AnyPublisher<LookBookEntity, Error> {
        let dictionary: [String: Any] = [
            "lookBookClothes": request
        ]
        let object = (try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)) ?? .init()
        
        return requestObjectWithNetworkError(.register(
            image: image,
            request: object
        ))
    }
    
    func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.lookbookDetail(id: id))
    }
    
    func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.lookbookList(parameters: parameters))
    }
    
    func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.lookbookClothes(parameters: parameters))
    }
    
    func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.deleteLookBook(id: id))
    }
    
}

