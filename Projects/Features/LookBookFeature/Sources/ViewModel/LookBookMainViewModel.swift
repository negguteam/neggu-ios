//
//  LookBookMainViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/6/25.
//

import Core
import Networks

import Foundation
import Combine

public final class LookBookMainViewModel: ObservableObject {
     
    // MARK: Input
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let lookBookDidScroll = PassthroughSubject<Void, Never>()
    let lookBookDidRefresh = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    @Published private(set) var userProfile: UserProfileEntity?
    @Published private(set) var lookBookState: UserLookBookState = .initial
    @Published private(set) var lookBookCalenar: [LookBookCalendarItem] = []
    @Published private(set) var lookBookList: [LookBookEntity] = []
    
    private var bag = Set<AnyCancellable>()
    
    private let lookBookUsecase: any LookBookUsecase
    private let userUsecase: any UserUsecase
    
    
    public init(
        lookBookUsecase: any LookBookUsecase,
        userUsecase: any UserUsecase
    ) {
        self.lookBookUsecase = lookBookUsecase
        self.userUsecase = userUsecase

        bind()
    }
    
    deinit {
        bag.removeAll()
    }
    
    
    private func bind() {
        viewDidAppear
            .filter { _ in self.lookBookList.isEmpty }
            .withUnretained(self)
            .sink { owner, _ in
                owner.userUsecase.fetchProfile()
                owner.lookBookUsecase.fetchLookBookList()
//                owner.lookBookUsecase.fetchRecentLookBook()
            }.store(in: &bag)
        
        lookBookDidScroll
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                owner.lookBookUsecase.fetchLookBookList()
            }.store(in: &bag)
        
        lookBookDidRefresh
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                owner.lookBookUsecase.resetLookBookList()
                owner.lookBookUsecase.fetchLookBookList()
            }.store(in: &bag)
        
        LookBookCalendarManager.shared.lookBookList
            .receive(on: RunLoop.main)
            .withUnretained(self)
            .sink { owner, lookBookList in
                print(lookBookList.map { ($0.id, $0.targetDate) })
                owner.lookBookCalenar = lookBookList
            }.store(in: &bag)
        
        lookBookUsecase.lookBookList
            .withUnretained(self)
            .sink { owner, lookBookList in
                owner.lookBookList = lookBookList
            }.store(in: &bag)
        
        lookBookUsecase.recentLookBook
            .withUnretained(self)
            .sink { owner, lookBook in
                owner.lookBookState = .available(lookBook)
            }.store(in: &bag)
        
        userUsecase.userProfile
            .withUnretained(self)
            .sink { owner, profile in
                owner.userProfile = profile
                
                if profile.clothes.isEmpty {
                    owner.lookBookState = .needClothes
                } else if profile.lookBooks.isEmpty {
                    owner.lookBookState = .needLookBook
                }
            }.store(in: &bag)
    }
    
}

extension LookBookMainViewModel {
        
    enum ProfileState {
        case initial
        case loaded(UserProfileEntity)
    }
    
}

enum UserLookBookState {
    case initial
    case needClothes
    case needLookBook
    case available(LookBookEntity)
}
