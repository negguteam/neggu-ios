//
//  LookBookViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/6/25.
//

import Foundation
import Combine

final class LookBookViewModel: ObservableObject {
    
    @Published private(set) var profileState: ProfileState = .unavailable
    @Published private(set) var lookbookState: LookBookState = .available
    
    @Published private(set) var lookBookList: [LookBookEntity] = []
    @Published var lookBookClothes: [ClothesEntity] = []
    
    @Published var selectedCategory: Category = .NONE
    @Published var selectedColor: ColorFilter?
    
    @Published private(set) var page: Int = 0
    @Published private(set) var clothesPage: Int = 0
    @Published private(set) var canPagenation: Bool = true
    @Published private(set) var canClothesPagenation: Bool = true
    
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
    
    func registerLookBook(image: Data, request: [LookBookClothesRegisterEntity], completion: @escaping () -> Void) {
        lookBookService.register(
            image: image,
            request: request
        ).sink { event in
            print("LookBookEditView", event)
        } receiveValue: { result in
            completion()
        }.store(in: &bag)
    }
    
    func negguInvite(completion: @escaping (NegguInviteEntity) -> Void) {
        lookBookService.negguInvite()
            .sink { event in
                print("LookBookView:", event)
            } receiveValue: { result in
                completion(result)
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
    
    func getLookBookClothes() {
        if !canClothesPagenation { return }
        canClothesPagenation = false
        
        var parameters: [String: Any] = ["page": clothesPage, "size": 6]
        
        if selectedCategory != .UNKNOWN && selectedCategory != .NONE {
            parameters["filterCategory"] = selectedCategory.id
        }
        
        if let color = selectedColor {
            parameters["colorGroup"] = color.id
        } else {
            parameters["colorGroup"] = "ALL"
        }
        
        lookBookService.lookbookClothes(parameters: parameters)
            .sink { event in
                print("LookBookEditView:", event)
            } receiveValue: { result in
                self.canClothesPagenation = !result.last
                self.clothesPage += result.last ? 0 : 1
                self.lookBookClothes += result.content
            }.store(in: &bag)
    }
    
    func filteredClothes() {
        $selectedCategory.combineLatest($selectedColor)
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] category, color in
                self?.resetLookBookClothes()
                self?.getLookBookClothes()
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
    
    func resetLookBookClothes() {
        clothesPage = 0
        canClothesPagenation = true
        lookBookClothes.removeAll()
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
