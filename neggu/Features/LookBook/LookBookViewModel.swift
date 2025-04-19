//
//  LookBookViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/6/25.
//

import Foundation
import Combine

final class LookBookViewModel: ObservableObject {
        
    // LookBookRegisterView
    @Published var lookBookClothes: [ClothesEntity] = []
    @Published var selectedCategory: Category = .NONE
    @Published var selectedColor: ColorFilter?
    @Published private(set) var clothesPage: Int = 0
    @Published private(set) var canClothesPagenation: Bool = true
    
    private let userService: UserService = DefaultUserService()
    private let closetService: ClosetService = DefaultClosetService()
    private let lookBookService: LookBookService = DefaultLookBookService()
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var bag = Set<AnyCancellable>()
    
    private var page: Int = 0
    private var canPagenation: Bool = true
    
    
    init() {
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
        case .fetchLookBookList:
            getLookBookList()
        case .refresh:
            fetchUserProfile()
            resetLookBookList()
        case .editNickname(let nickname):
            print(nickname)
        case .deleteLookBookList(let idList):
            print(idList)
        }
    }
    
    
    private func fetchUserProfile() {
        userService.profile()
            .sink { event in
                print("LookBookMainView:", event)
            } receiveValue: { [weak self] profile in
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
                    guard let lookBook = self?.output.lookBookList.first else { return }
                    self?.output.lookBookState = .available(lookBook)
                }
            }.store(in: &bag)
    }
    
    func deleteLookBook(id: String, completion: @escaping () -> Void) {
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
    
    func registerLookBook(
        image: Data,
        request: [LookBookClothesRegisterEntity],
        inviteCode: String = "",
        completion: @escaping () -> Void
    ) {
        lookBookService.register(
            image: image,
            request: request,
            inviteCode: inviteCode
        ).sink { event in
            print("LookBookRegisterView", event)
        } receiveValue: { result in
            completion()
        }.store(in: &bag)
    }
    
    func negguInvite(completion: @escaping (NegguInviteEntity) -> Void) {
        lookBookService.negguInvite()
            .sink { event in
                print("LookBookMainView:", event)
            } receiveValue: { result in
                completion(result)
            }.store(in: &bag)
    }
    
    func getLookBookClothes(inviteCode: String) {
        if !canClothesPagenation { return }
        canClothesPagenation = false
        
        var parameters: [String: Any] = ["page": clothesPage, "size": 6]
        
        if selectedCategory != .UNKNOWN && selectedCategory != .NONE {
            parameters[inviteCode.isEmpty ? "filterCategory" : "category"] = selectedCategory.id
        }
        
        if let color = selectedColor {
            parameters["colorGroup"] = color.id
        } else {
            parameters["colorGroup"] = "ALL"
        }
        
        if inviteCode.isEmpty {
            lookBookService.lookbookClothes(parameters: parameters)
                .sink { event in
                    print("LookBookRegisterView:", event)
                } receiveValue: { result in
                    self.canClothesPagenation = !result.last
                    self.clothesPage += result.last ? 0 : 1
                    self.lookBookClothes += result.content
                }.store(in: &bag)
        } else {
            parameters["inviteCode"] = inviteCode
            
            closetService.clothesInviteList(parameters: parameters)
                .sink { event in
                    print("LookBookRegisterView:", event)
                } receiveValue: { result in
                    self.canClothesPagenation = !result.last
                    self.clothesPage += result.last ? 0 : 1
                    self.lookBookClothes += result.content
                }.store(in: &bag)
        }
    }
    
    func filteredClothes(inviteCode: String) {
        $selectedCategory.combineLatest($selectedColor)
            .removeDuplicates { $0 == $1 }
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category, color in
                self?.resetLookBookClothes()
                self?.getLookBookClothes(inviteCode: inviteCode)
            }.store(in: &bag)
    }
    
    func resetLookBookClothes() {
        clothesPage = 0
        canClothesPagenation = true
        lookBookClothes.removeAll()
    }
    
}

extension LookBookViewModel {
    
    struct State {
        var profileState: ProfileState = .initial
        var lookBookState: LookBookState = .initial
        var lookBookList: [LookBookEntity] = []
    }
    
    enum Action {
        case fetchLookBookList
        case refresh
        case editNickname(String)
        case deleteLookBookList([String])
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
