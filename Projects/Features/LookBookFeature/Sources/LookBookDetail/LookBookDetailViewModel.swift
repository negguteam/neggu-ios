//
//  LookBookDetailViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import Core
import Domain

import LookBookFeatureInterface

import Foundation
import Combine
import UserNotifications

final class LookBookDetailViewModel: ObservableObject {
    
    // MARK: Input
    let viewDidAppear = PassthroughSubject<String, Never>()
    let deleteButtonDidTap = PassthroughSubject<String, Never>()
    
    // MARK: Output
    @Published private(set) var lookBookDetail: LookBookEntity?
    
    private var bag = Set<AnyCancellable>()
    
    private let router: any LookBookDetailRoutable
    private let lookBookUsecase: any LookBookUsecase
    
    init(
        router: any LookBookDetailRoutable,
        lookBookUsecase: any LookBookUsecase
    ) {
        self.router = router
        self.lookBookUsecase = lookBookUsecase
        
        bind()
    }
    
    deinit {
        bag.removeAll()
        debugPrint("\(self) deinit")
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
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [lookBook.id])
                    owner.pop()
                } else {
                    AlertManager.shared.setAlert(message: "코디 삭제에 실패했습니다. 다시 시도해주세요.")
                }
            }.store(in: &bag)
    }
    
    func presentClothesDetail(_ id: String) {
        router.presentClothesDetail(id: id)
    }
    
    func pop() {
        router.pop()
    }
    
}
