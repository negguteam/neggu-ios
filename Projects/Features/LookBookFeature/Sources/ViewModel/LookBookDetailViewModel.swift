//
//  LookBookDetailViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import Core
import Networks

import Foundation
import Combine

final class LookBookDetailViewModel: ObservableObject {
    
    // MARK: Input
    let viewDidAppear = PassthroughSubject<String, Never>()
    let deleteButtonDidTap = PassthroughSubject<String, Never>()
    
    // MARK: Output
    @Published private(set) var lookBookDetail: LookBookEntity?
    @Published private(set) var deleteState: DeleteState = .idle
    
    private var bag = Set<AnyCancellable>()
    
    private let lookBookUsecase: any LookBookUsecase
    
    init(lookBookUsecase: any LookBookUsecase) {
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
            .sink { owner, lookBookID in
                owner.lookBookUsecase.fetchLookBookDetail(lookBookID)
            }.store(in: &bag)
        
        deleteButtonDidTap
            .withUnretained(self)
            .sink { owner, lookBookID in
                owner.lookBookUsecase.deleteLookBook(lookBookID)
            }.store(in: &bag)
        
        lookBookUsecase.lookBookDetail
            .withUnretained(self)
            .sink { owner, lookBook in
                owner.lookBookDetail = lookBook
            }.store(in: &bag)
        
        lookBookUsecase.deletedLookBook
            .withUnretained(self)
            .sink { owner, lookBook in
                if let lookBook {
                    LookBookCalendarManager.shared.removeLookBook(id: lookBook.id)
                    owner.deleteState = .success
                } else {
                    owner.deleteState = .failure
                }
            }.store(in: &bag)
    }
    
    enum DeleteState: Equatable {
        case idle
        case success
        case failure
    }
    
}
