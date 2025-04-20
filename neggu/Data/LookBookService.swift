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
    func register(image: Data, request: [LookBookClothesRegisterEntity], inviteCode: String) -> AnyPublisher<LookBookEntity, Error>
    func negguInvite() -> AnyPublisher<NegguInviteEntity, Error>
    func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error>
    func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookListEntity, Error>
    func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error>
}

extension DefaultLookBookService: LookBookService {
    
    func register(image: Data, request: [LookBookClothesRegisterEntity], inviteCode: String) -> AnyPublisher<LookBookEntity, Error> {
        let requestArray = request.compactMap {
            let jsonData = (try? JSONEncoder().encode($0)) ?? .init()
            return try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
        }
        
        var dictionary: [String: Any] = [
            "lookBookClothes": requestArray,
            "targetDate": Date.now.toISOEncodableFormatString(),
        ]
        
        if !inviteCode.isEmpty {
            dictionary["inviteCode"] = inviteCode
        }
        
        let object = try? JSONSerialization.data(withJSONObject: dictionary)
        
        return requestObjectWithNetworkError(
            inviteCode.isEmpty
            ? .register(image: image,request: object ?? .init())
            : .registerByInvite(image: image, request: object ?? .init())
        )
    }
    
    func negguInvite() -> AnyPublisher<NegguInviteEntity, Error> {
        return requestObjectWithNetworkError(.negguInvite)
    }
    
    func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.lookbookDetail(id: id))
    }
    
    func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookListEntity, Error> {
        requestObjectWithNetworkError(.lookbookList(parameters: parameters))
    }
    
    func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.lookbookClothes(parameters: parameters))
    }
    
    func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.deleteLookBook(id: id))
    }
    
}

