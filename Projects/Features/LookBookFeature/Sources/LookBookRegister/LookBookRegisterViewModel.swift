//
//  LookBookRegisterViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import Core
import Domain

import BaseFeature
import LookBookFeatureInterface

import Foundation
import Combine

final class LookBookRegisterViewModel: ObservableObject {
    
    // MARK: Input
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let closetDidScroll = PassthroughSubject<Void, Never>()
    let categoryDidSelect = PassthroughSubject<Core.Category, Never>()
    let registerButtonDidTap = PassthroughSubject<(Data, [LookBookClothesItem]), Never>()
    
    // MARK: Output
    @Published private(set) var clothesList: [ClothesEntity] = []
    @Published private(set) var filter: ClothesFilter = .init()
    @Published var isEmptyCloset: Bool = false

    private var page: Int = 0
    private var isLoading: Bool = true
    
    private var bag = Set<AnyCancellable>()
    
    private let router: any LookBookRegisterRoutable
    private let lookBookUsecase: any LookBookUsecase
    
    init(
        router: any LookBookRegisterRoutable,
        lookBookUsecase: any LookBookUsecase
    ) {
        self.router = router
        self.lookBookUsecase = lookBookUsecase
        
        bind()
        print("\(self) init")
    }
    
    deinit {
        bag.removeAll()
        print("\(self) deinit")
    }
    
    
    private func bind() {
        viewDidAppear
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchCloset()
            }.store(in: &bag)
        
        closetDidScroll
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .filter { owner, _ in !owner.isLoading }
            .sink { owner, _ in
                owner.isLoading = true
                owner.fetchCloset()
            }.store(in: &bag)
        
        categoryDidSelect
            .withUnretained(self)
            .sink { owner, category in
                owner.filter.category = category
                owner.resetCloset()
                owner.fetchCloset()
            }.store(in: &bag)
        
        registerButtonDidTap
            .throttle(for: .seconds(3), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, request in
                owner.lookBookUsecase.registerLookBook(
                    image: request.0,
                    request: request.1.compactMap { $0.toEntity() }
                )
            }.store(in: &bag)
        
        lookBookUsecase.lookBookCloset
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, result in
                guard result.totalPages != 0 else {
                    owner.isEmptyCloset = true
                    return
                }
                
                owner.isLoading = result.last
                owner.page += result.last ? 0 : 1
                owner.clothesList += result.content
            }.store(in: &bag)
        
        lookBookUsecase.registeredLookBook
            .withUnretained(self)
            .sink { owner, lookBook in
                if lookBook != nil {
                    owner.dismiss()
                } else {
                    AlertManager.shared.setAlert(message: "룩북 등록에 실패했습니다. 다시 시도해주세요.")
                }
            }.store(in: &bag)
    }
    
    private func fetchCloset() {
        var parameters: [String: Any] = ["page": page, "size": 6]
        
        if filter.category != .UNKNOWN && filter.category != .NONE {
            parameters["filterCategory"] = filter.category.id
        }
        
        parameters["colorGroup"] = "ALL"
        
        lookBookUsecase.fetchLookBookCloset(parameters: parameters)
    }
    
    private func resetCloset() {
        page = 0
        clothesList = []
        isLoading = false
    }
    
    func dismiss() {
        router.dismiss()
    }
    
}

struct ClothesFilter {
    var category: Core.Category = .NONE
}
