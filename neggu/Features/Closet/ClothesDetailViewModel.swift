//
//  ClothesDetailViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/17/25.
//

import Foundation
import Combine

final class ClothesDetailViewModel: ObservableObject {
    
    private let closetService: ClosetService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var state: State = .initial
    
    private var bag = Set<AnyCancellable>()
    
    
    init(closetService: ClosetService = DefaultClosetService()) {
        self.closetService = closetService
        
        input
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: true)
            .sink { self.transform(from: $0) }
            .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    
    func send(action: Action) {
        input.send(action)
    }
    
    private func transform(from action: Action) {
        switch action {
        case .fetchClothes(let id):
            getClothesDetail(id)
        case .onTapModify(let clothes, let completion):
            modifyClothes(clothes, completion: completion)
        case .onTapDelete(let id, let completion):
            deleteClothes(id, completion: completion)
        }
    }
    
    private func getClothesDetail(_ id: String) {
        closetService.clothesDetail(id: id)
            .sink { event in
                print("ClosetDetail:", event)
            } receiveValue: { [weak self] clothes in
                self?.state = .loaded(ClothesDetail(entity: clothes))
            }.store(in: &bag)
    }
    
    private func modifyClothes(_ clothes: ClothesEntity, completion: @escaping () -> Void) {
        closetService.modify(clothes)
            .sink { event in
                print("ClosetDetail:", event)
            } receiveValue: { _ in
                completion()
            }.store(in: &bag)
    }
    
    private func deleteClothes(_ id: String, completion: @escaping () -> Void) {
        closetService.deleteClothes(id: id)
            .sink { event in
                print("ClothesDetail:", event)
            } receiveValue: { _ in
                completion()
            }.store(in: &bag)
    }
    
}


extension ClothesDetailViewModel {
    
    enum State {
        case initial
        case loaded(ClothesDetail)
    }
    
    enum Action {
        case fetchClothes(id: String)
        case onTapModify(clothes: ClothesEntity, completion: () -> Void)
        case onTapDelete(id: String, completion: () -> Void)
    }
    
    struct ClothesDetail {
        let id: String
        let name: String
        let imageUrl: String
        let category: Category
        let subCategory: SubCategory
        let moodList: [Mood]
        let brand: String
        let priceRange: PriceRange
        let link: String
        let memo: String
        let colorCode: String
        let color: String

        init(entity: ClothesEntity) {
            self.id = entity.id
            self.name = entity.name
            self.imageUrl = entity.imageUrl
            self.category = entity.category
            self.subCategory = entity.subCategory
            self.moodList = entity.mood
            self.brand = entity.brand
            self.priceRange = entity.priceRange
            self.link = entity.link
            self.memo = entity.memo
            self.colorCode = entity.colorCode
            self.color = entity.color
        }
        
        var categoryString: String {
            [category.title, subCategory.title].joined(separator: " > ")
        }
        
        var moodString: String {
            if moodList.isEmpty {
                "옷의 분위기"
            } else {
                moodList.map { $0.title }.joined(separator: ", ")
            }
        }
    }
    
}
