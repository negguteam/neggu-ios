//
//  LookBookViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/6/25.
//

import Foundation
import Combine

final class LookBookViewModel: ObservableObject {
    
    @Published var profileState: ProfileState = .unavailable
    @Published var lookbookState: LookBookState = .available
    
    @Published var lookBookList: [LookBookEntity] = []
    @Published var page: Int = 0
    @Published var canPagenation: Bool = true
    
    private let userService: UserService = DefaultUserService()
    private let lookBookService = DefaultLookBookService()
    
    private var bag = Set<AnyCancellable>()
    
    
    init() { }
    
    
    func fetchProfile() {
        userService.profile()
            .sink { event in
                print("UserProfile:", event)
            } receiveValue: { profile in
                self.profileState = .available(profile: profile)
                
                if profile.clothes.isEmpty {
                    self.lookbookState = .needClothes
                } else if profile.lookBooks.isEmpty {
                    self.lookbookState = .none
                } else {
                    self.lookbookState = .available
                }
            }.store(in: &bag)
    }
    
    func getLookBookList() {
        if !canPagenation { return }
        canPagenation = false
        
        lookBookService.lookbookList(parameters: ["page": page, "size": 6])
            .sink { event in
                print("LookBookView:", event)
            } receiveValue: { result in
                self.canPagenation = !result.last
                self.page += !result.last ? 1 : 0
                self.lookBookList += result.content
            }.store(in: &bag)
    }
    
    func getLookBookDetail(id: String, completion: @escaping (LookBookEntity) -> Void) {
        lookBookService.lookbookDetail(id: id)
            .sink { event in
                print("LookBookDetailView:", event)
            } receiveValue: { lookBook in
                completion(lookBook)
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
    
    func resetLookBookList() {
        resetPage()
        lookBookList.removeAll()
    }
    
    func resetPage() {
        page = 0
        canPagenation = true
    }
    
 
    enum ProfileState {
        case available(profile: UserProfileEntity)
        case unavailable
    }
    
    enum LookBookState {
        case available
        case none
        case needClothes
    }
}
