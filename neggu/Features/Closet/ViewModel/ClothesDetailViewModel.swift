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
        case .onTapDelete(let id, let completion):
            deleteClothes(id, completion: completion)
        }
    }
    
    private func getClothesDetail(_ id: String) {
        closetService.clothesDetail(id: id)
            .sink { event in
                print("ClothesDetail:", event)
            } receiveValue: { [weak self] clothes in
                self?.state = .loaded(clothes)
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
        case loaded(ClothesEntity)
    }
    
    enum Action {
        case fetchClothes(id: String)
        case onTapDelete(id: String, completion: () -> Void)
    }
    
}
