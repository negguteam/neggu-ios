//
//  ClosetService.swift
//  Domain
//
//  Created by 유지호 on 7/6/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Foundation
import Combine

public protocol ClosetService {
    func register(image: Data, request: ClothesRegisterEntity) -> AnyPublisher<ClothesEntity, Error>
    func modify(_ clothes: ClothesEntity) -> AnyPublisher<ClothesEntity, Error>
    func clothesDetail(id: String) -> AnyPublisher<ClothesEntity, Error>
    func clothesList(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func clothesInviteList(parameters: [String: Any]) -> AnyPublisher<ClosetEntity, Error>
    func brandList() -> AnyPublisher<[BrandEntity], Error>
    func deleteClothes(id: String) -> AnyPublisher<ClothesEntity, Error>
}
