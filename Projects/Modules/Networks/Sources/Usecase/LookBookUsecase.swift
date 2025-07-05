//
//  LookBookUsecase.swift
//  Networks
//
//  Created by 유지호 on 7/2/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Core

import Foundation
import Combine

public protocol LookBookUsecase {
    var lookBookList: CurrentValueSubject<[LookBookEntity], Never> { get }
    var lookBookDetail: PassthroughSubject<LookBookEntity, Never> { get }
    var lookBookCloset: PassthroughSubject<ClosetEntity, Never> { get }
    var recentLookBook: PassthroughSubject<LookBookEntity, Never> { get }
    var registeredLookBook: PassthroughSubject<LookBookEntity?, Never> { get }
    var deletedLookBook: PassthroughSubject<LookBookEntity?, Never> { get }
    
    func fetchLookBookList()
    func fetchLookBookDetail(_ id: String)
    func fetchLookBookCloset(parameters: [String: Any])
    func fetchRecentLookBook()
    func registerLookBook(image: Data, request: [LookBookClothesRegisterEntity])
    func deleteLookBook(_ id: String)
    func resetLookBookList()
}

public final class DefaultLookBookUsecase: LookBookUsecase {
    
    public let lookBookList = CurrentValueSubject<[LookBookEntity], Never>([])
    public let lookBookDetail = PassthroughSubject<LookBookEntity, Never>()
    public let lookBookCloset = PassthroughSubject<ClosetEntity, Never>()
    public let recentLookBook = PassthroughSubject<LookBookEntity, Never>()
    public let registeredLookBook = PassthroughSubject<LookBookEntity?, Never>()
    public let deletedLookBook = PassthroughSubject<LookBookEntity?, Never>()
    
    private var isLoading: Bool = false
    private var page: Int = 0
    
    private var bag = Set<AnyCancellable>()

    private let lookBookService: any LookBookService
    
    public init(lookBookService: any LookBookService) {
        self.lookBookService = lookBookService
    }
    
    
    public func fetchLookBookList() {
        if isLoading { return }
        isLoading = true
        
        lookBookService.lookbookList(parameters: ["page": page, "size": 6])
            .withUnretained(self)
            .sink { event in
                print("FetchLookBookList:", event)
            } receiveValue: { owner, result in
                owner.isLoading = result.last
                owner.page += result.last ? 0 : 1
                
                var current = owner.lookBookList.value
                current += result.content
                owner.lookBookList.send(current)
            }.store(in: &bag)
    }
    
    public func fetchLookBookDetail(_ id: String) {
        lookBookService.lookbookDetail(id: id)
            .withUnretained(self)
            .sink { event in
                print("FetchLookBookDetail:", event)
            } receiveValue: { owner, lookBook in
                owner.lookBookDetail.send(lookBook)
            }.store(in: &bag)
    }
    
    public func fetchRecentLookBook() {
        guard let lookBook = lookBookList.value.filter({ $0.decorator != nil }).first,
              let targetDate = lookBook.decorator?.targetDate.toISOFormatDate(),
              targetDate.yearMonthDay() >= .now.yearMonthDay()
        else { return }
        
        recentLookBook.send(lookBook)
    }
    
    public func fetchLookBookCloset(parameters: [String: Any]) {
        lookBookService.lookbookClothes(parameters: parameters)
            .withUnretained(self)
            .sink { event in
                print("FetchLookBookCloset:", event)
            } receiveValue: { owner, closet in
                owner.lookBookCloset.send(closet)
            }.store(in: &bag)
    }
    
    public func registerLookBook(image: Data, request: [LookBookClothesRegisterEntity]) {
        lookBookService.register(image: image, request: request, inviteCode: "")
            .withUnretained(self)
            .sink { [weak self] event in
                print("RegisterLookBook:", event)
                
                switch event {
                case .finished:
                    print("RegisterLookBook:", event)
                case .failure:
                    self?.registeredLookBook.send(nil)
                }
            } receiveValue: { owner, lookBook in
                owner.registeredLookBook.send(lookBook)
                owner.resetLookBookList()
                owner.fetchLookBookList()
            }.store(in: &bag)
    }
    
    public func deleteLookBook(_ id: String) {
        lookBookService.deleteLookBook(id: id)
            .withUnretained(self)
            .sink { event in
                print("DeleteLookBook:", event)
            } receiveValue: { owner, lookBook in
                owner.resetLookBookList()
                owner.fetchLookBookList()
                owner.deletedLookBook.send(lookBook)
            }.store(in: &bag)
    }
    
    public func resetLookBookList() {
        page = 0
        isLoading = false
        lookBookList.send([])
    }
    
}


public final class MockLookBookUsecase: LookBookUsecase {
    
    public let lookBookList = CurrentValueSubject<[LookBookEntity], Never>([])
    public let lookBookDetail = PassthroughSubject<LookBookEntity, Never>()
    public let lookBookCloset = PassthroughSubject<ClosetEntity, Never>()
    public let recentLookBook = PassthroughSubject<LookBookEntity, Never>()
    public let registeredLookBook = PassthroughSubject<LookBookEntity?, Never>()
    public let deletedLookBook = PassthroughSubject<LookBookEntity?, Never>()
    
    private var isLoading: Bool = false
    private var page: Int = 0
    
    private var bag = Set<AnyCancellable>()
    
    public init() { }
    
    public func fetchLookBookList() {
        if isLoading { return }
        
        let mockList: [LookBookEntity] = ((page * 6)...((page + 1) * 6 - 1)).map {
            .init(
                id: "\($0)",
                accountId: "\($0)",
                lookBookId: "\($0)",
                imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
                lookBookClothes: [],
                decorator: nil,
                createdAt: "",
                modifiedAt: ""
            )
        }
        
        isLoading = page == 2
        page += 1
        
        var current = lookBookList.value
        current += mockList
        lookBookList.send(current)
    }
    
    public func fetchLookBookDetail(_ id: String) {
        let mock = LookBookEntity(
            id: id,
            accountId: id,
            lookBookId: id,
            imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
            lookBookClothes: (0...3).map {
                .init(
                    id: "\($0)",
                    imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
                    scale: 1.0,
                    angle: [0, 90, 180, 360].randomElement() ?? 0,
                    xRatio: [0, 50, 100, 150].randomElement() ?? 0,
                    yRatio: [0, 50, 100, 150].randomElement() ?? 0,
                    zIndex: $0
                )
            },
            decorator: nil,
            createdAt: "",
            modifiedAt: Date.now.toISOFormatString()
        )
        
        lookBookDetail.send(mock)
    }
    
    public func fetchLookBookCloset(parameters: [String : Any]) {
        let page = parameters["page"] as? Int ?? 1
        
        let mockList: [ClothesEntity] = ((page * 6)...((page + 1) * 6 - 1)).map {
            .init(
                id: "\($0)",
                accountId: "\($0)",
                clothId: "\($0)",
                name: "의상\($0)",
                link: "www.neggu.com",
                imageUrl: "https://cdn.tvj.co.kr/news/photo/202504/108548_248894_2935.jpg",
                category: Category.allCasesArray.randomElement() ?? .TOP,
                subCategory: SubCategory.allCasesArray.randomElement() ?? .T_SHIRT,
                mood: [.MODERN],
                brand: "Neggu",
                priceRange: .UNKNOWN,
                memo: "테스트 메모",
                color: "",
                colorCode: "",
                isPurchase: Bool.random(),
                modifiedAt: Date.now.toISOFormatString()
            )
        }
        
        let mock: ClosetEntity = .init(
            totalElements: 12,
            totalPages: 2,
            size: 12,
            content: mockList,
            number: 0,
            numberOfElements: 12,
            first: page == 0,
            last: page == 1,
            empty: false
        )
        
        lookBookCloset.send(mock)
    }
    
    public func fetchRecentLookBook() {
        
    }
    
    public func registerLookBook(image: Data, request: [LookBookClothesRegisterEntity]) {
        let mock = LookBookEntity(
            id: "abcd",
            accountId: "abcd",
            lookBookId: "abcd",
            imageUrl: "",
            lookBookClothes: [],
            decorator: nil,
            createdAt: "",
            modifiedAt: Date.now.toISOFormatString()
        )
        
        registeredLookBook.send(mock)
        resetLookBookList()
        fetchLookBookList()
    }
    
    public func deleteLookBook(_ id: String) {
        let lookBook = lookBookList.value.first(where: { $0.id == id })
        var current = lookBookList.value
        current.removeAll(where: { $0.id == id })
        lookBookList.send(current)
        deletedLookBook.send(lookBook)
    }
    
    public func resetLookBookList() {
        page = 0
        isLoading = false
        lookBookList.send([])
    }
    
}
