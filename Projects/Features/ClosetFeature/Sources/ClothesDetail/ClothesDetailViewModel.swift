//
//  ClothesDetailViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/17/25.
//

import Core
import Domain

import BaseFeature
import ClosetFeatureInterface

import Foundation
import Combine

public final class ClothesDetailViewModel: ObservableObject {
    
    // MARK: Input
    let clothesFetch = PassthroughSubject<String, Never>()
    let deleteButtonDidTap = PassthroughSubject<String, Never>()
    
    // MARK: Output
    @Published private(set) var clothes: ClothesEntity?
    
    private let router: any ClothesDetailRoutable
    private let closetUsecase: any ClosetUsecase
    
    private var bag = Set<AnyCancellable>()
    
    public init(
        router: any ClothesDetailRoutable,
        closetUsecase: any ClosetUsecase
    ) {
        self.router = router
        self.closetUsecase = closetUsecase
        
        bind()
        print("\(self) init")
    }
    
    deinit {
        bag.removeAll()
        print("\(self) deinit")
    }
    
    
    private func bind() {
        clothesFetch
            .withUnretained(self)
            .sink { owner, clothesId in
                owner.closetUsecase.fetchClothesDetail(clothesId)
            }.store(in: &bag)
        
        deleteButtonDidTap
            .withUnretained(self)
            .sink { owner, clothesId in
                owner.closetUsecase.deleteClothes(clothesId)
            }.store(in: &bag)
        
        closetUsecase.clothes
            .compactMap { $0 }
            .withUnretained(self)
            .sink { owner, clothes in
                owner.clothes = clothes
            }.store(in: &bag)
    }
    
    public func pushToModify(_ clothes: ClothesEntity) {
        router.routeToModify(clothes)
    }
    
    public func dismiss() {
        router.dismiss()
    }
    
}
