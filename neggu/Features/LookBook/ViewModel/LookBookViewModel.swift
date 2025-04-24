//
//  LookBookViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/6/25.
//

import Foundation
import Combine

final class LookBookViewModel: ObservableObject {
        
    private let userService: any UserService
    private let closetService: any ClosetService
    private let lookBookService: any LookBookService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var bag = Set<AnyCancellable>()
    
    private var page: Int = 0
    private var canPagenation: Bool = true
    
    
    init(
        userService: any UserService,
        closetService: any ClosetService,
        lookBookService: any LookBookService
    ) {
        self.userService = userService
        self.closetService = closetService
        self.lookBookService = lookBookService
        
        fetchUserProfile()
        
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
        case .fetchUserProfile:
            fetchUserProfile()
        case .fetchLookBookList:
            getLookBookList()
        case .refresh:
            fetchUserProfile()
            resetLookBookList()
            getLookBookList()
        case .editNickname(let nickname):
            print(nickname)
        case .deleteLookBookList(let idList):
            print(idList)
        case .generateNeggu(let completion):
            negguInvite(completion: completion)
        }
    }
    
    private func fetchUserProfile() {
        userService.profile()
            .sink { event in
                print("LookBookMainView:", event)
            } receiveValue: { [weak self] profile in
                UserDefaultsKey.User.nickname = profile.nickname
                self?.output.profileState = .loaded(profile)
                
                if profile.clothes.isEmpty {
                    self?.output.lookBookState = .needClothes
                } else {
                    self?.output.lookBookState = .needLookBook
                }
            }.store(in: &bag)
    }
    
    private func getLookBookList() {
        if !canPagenation { return }
        canPagenation = false
        
        lookBookService.lookbookList(parameters: ["page": page, "size": 6])
            .sink { event in
                print("LookBookMainView:", event)
            } receiveValue: { [weak self] result in
                self?.canPagenation = !result.last
                self?.page += !result.last ? 1 : 0
                self?.output.lookBookList += result.content
                
                if result.first {
                    if let lookBook = self?.output.lookBookList.filter({ $0.decorator != nil }).first,
                       let targetDate = lookBook.decorator?.targetDate.toISOFormatDate()?.yearMonthDay(),
                       targetDate >= .now.yearMonthDay() {
                        self?.output.lookBookState = .available(lookBook)
                    } else if let lookBook = self?.output.lookBookList.first {
                        self?.output.lookBookState = .available(lookBook)
                    }
                }
            }.store(in: &bag)
    }
    
    private func deleteLookBook(id: String, completion: @escaping () -> Void) {
        lookBookService.deleteLookBook(id: id)
            .sink { event in
                print("LookBookDetailView:", event)
            } receiveValue: { lookBook in
                self.resetLookBookList()
                completion()
            }.store(in: &bag)
    }
    
    private func resetLookBookList() {
        resetPage()
        output.lookBookList.removeAll()
    }
    
    private func resetPage() {
        page = 0
        canPagenation = true
    }
    
    private func negguInvite(completion: @escaping (NegguInviteEntity) -> Void) {
        lookBookService.negguInvite()
            .sink { event in
                print("LookBookMainView:", event)
            } receiveValue: { result in
                completion(result)
            }.store(in: &bag)
    }
    
}

extension LookBookViewModel {
    
    struct State {
        var profileState: ProfileState = .initial
        var lookBookState: LookBookState = .initial
        var lookBookList: [LookBookEntity] = []
    }
    
    enum Action {
        case fetchUserProfile
        case fetchLookBookList
        case refresh
        case editNickname(String)
        case deleteLookBookList([String])
        case generateNeggu(completion: (NegguInviteEntity) -> Void)
    }
    
    enum ProfileState {
        case initial
        case loaded(UserProfileEntity)
    }
    
    enum LookBookState {
        case initial
        case needClothes
        case needLookBook
        case available(LookBookEntity)
    }
    
}
