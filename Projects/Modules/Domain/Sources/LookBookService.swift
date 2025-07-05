//
//  LookBookService.swift
//  Domain
//
//  Created by 유지호 on 7/6/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Foundation
import Combine

public protocol LookBookService {
    func register(image: Data, request: [LookBookClothesRegisterEntity], inviteCode: String) -> AnyPublisher<LookBookEntity, Error>
    func negguInvite() -> AnyPublisher<NegguInviteEntity, Error>
    func lookbookDetail(id: String) -> AnyPublisher<LookBookEntity, Error>
    func lookbookList(parameters: [String: Any]) -> AnyPublisher<LookBookListEntity, Error>
    func lookbookClothes(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func modifyDate(id: String, targetDate: String) -> AnyPublisher<LookBookEntity, Error>
    func deleteLookBook(id: String) -> AnyPublisher<LookBookEntity, Error>
}
