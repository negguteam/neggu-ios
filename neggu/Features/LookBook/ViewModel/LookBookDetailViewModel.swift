//
//  LookBookDetailViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//


import Foundation
import Combine

final class LookBookDetailViewModel: ObservableObject {
    
    private let lookBookService: LookBookService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var state: State = .initial
    
    private var bag = Set<AnyCancellable>()
    
    
    init(lookBookService: LookBookService = DefaultLookBookService()) {
        self.lookBookService = lookBookService
        
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
        case .fetchLookBook(let id):
            getLookBookDetail(id: id)
        case .onTapDelete(let id, let completion):
            deleteLookBook(id: id, completion: completion)
        }
    }
    
    private func getLookBookDetail(id: String) {
        lookBookService.lookbookDetail(id: id)
            .sink { event in
                print("LookBookDetailView:", event)
            } receiveValue: { [weak self] lookBook in
                self?.state = .loaded(lookBook)
            }.store(in: &bag)
    }
    
    private func deleteLookBook(id: String, completion: @escaping () -> Void) {
        lookBookService.deleteLookBook(id: id)
            .sink { event in
                print("LookBookDetailView:", event)
            } receiveValue: { lookBook in
                completion()
            }.store(in: &bag)
    }
    
}


extension LookBookDetailViewModel {
    
    enum State {
        case initial
        case loaded(LookBookEntity)
    }
    
    enum Action {
        case fetchLookBook(id: String)
        case onTapDelete(id: String, completion: () -> Void)
    }
    
}
