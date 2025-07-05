//
//  LookBookService.swift
//  neggu
//
//  Created by 유지호 on 2/14/25.
//

import Core
import Domain

import Foundation
import Combine

public typealias DefaultLookBookService = BaseService<LookBookAPI>

extension DefaultLookBookService: LookBookService {
    
    public func register(image: Data, request: [LookBookClothesRegisterEntity], inviteCode: String) -> AnyPublisher<LookBookEntity, Error> {
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
    
    public func negguInvite() -> AnyPublisher<NegguInviteEntity, Error> {
        return requestObjectWithNetworkError(.negguInvite)
    }
    
    public func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.lookbookDetail(id: id))
    }
    
    public func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookListEntity, Error> {
        requestObjectWithNetworkError(.lookbookList(parameters: parameters))
    }
    
    public func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error> {
        requestObjectWithNetworkError(.lookbookClothes(parameters: parameters))
    }
    
    public func modifyDate(id: String, targetDate: String) -> AnyPublisher<LookBookEntity, any Error> {
        requestObjectWithNetworkError(.modifyDate(id: id, targetDate: targetDate))
    }
    
    public func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error> {
        requestObjectWithNetworkError(.deleteLookBook(id: id))
    }
    
}

