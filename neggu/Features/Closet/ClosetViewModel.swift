//
//  ClosetViewModel.swift
//  neggu
//
//  Created by 유지호 on 2/5/25.
//

import Foundation
import Combine

final class ClosetViewModel: ObservableObject {
    
    private let closetService: ClosetService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var page: Int = 0
    private var canPagenation: Bool = true
    
    private var bag = Set<AnyCancellable>()
    
    
    init(closetService: ClosetService = DefaultClosetService()) {
        self.closetService = closetService

        input
            .throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: true)
            .sink { self.transform(from: $0) }
            .store(in: &bag)
    }
    
    
    func send(action: Action) {
        input.send(action)
    }
    
    private func transform(from action: Action) {
        switch action {
        case .onAppear:
            print("onAppear")
        case .fetchClothesList:
            getClothes()
        case .selectFilter(let filter):
            filteredClothes(filter: filter)
        case .refresh:
            resetCloset()
        }
    }
        
    func getClothes() {
        if !canPagenation { return }
        canPagenation = false
        
        var parameters: [String: Any] = ["page": page, "size": 18]
        
        let category = output.filter.category
        let subCategory = output.filter.subCategory
        let mood = output.filter.mood
        let color = output.filter.color
        
        if subCategory == .UNKNOWN {
            if category != .UNKNOWN {
                parameters["category"] = category.id
            }
        } else {
            parameters["subCategory"] = subCategory.id
        }
        
        if mood != .UNKNOWN {
            parameters["mood"] = mood.id
        }
        
        if let color {
            parameters["colorGroup"] = color.id
        }
        
        closetService.clothesList(parameters: parameters)
            .sink { event in
                print("ClosetView:", event)
            } receiveValue: { result in
                self.canPagenation = !result.last
                self.output.clothes += result.content
                self.page += !result.last ? 1 : 0
            }.store(in: &bag)
    }
    
    func filteredClothes(filter: ClothesFilter) {
        output.filter = filter
        resetCloset()
        getClothes()
    }
    
    func resetCloset() {
        resetPage()
        output.clothes.removeAll()
    }
    
    func resetPage() {
        page = 0
        canPagenation = true
    }
    
    func registerClothes(
        image: Data,
        clothes: ClothesRegisterEntity,
        completion: @escaping () -> Void
    ) {
        closetService.register(
            image: image,
            request: clothes
        ).sink { event in
            print("ClosetAdd:", event)
        } receiveValue: { result in
            debugPrint(result)
            self.resetCloset()
            self.getClothes()
            completion()
        }.store(in: &bag)
    }
    
    func modifyClothes(_ clothes: ClothesEntity, completion: @escaping () -> Void) {
        closetService.modify(clothes)
            .sink { event in
                print("ClosetAdd:", event)
            } receiveValue: { _ in
                completion()
            }.store(in: &bag)
    }
    
    func getClothesDetail(_ id: String, completion: @escaping (ClothesEntity) -> Void) {
        closetService.clothesDetail(id: id)
            .sink { event in
                print("ClosetDetail:", event)
            } receiveValue: { clothes in
                completion(clothes)
            }.store(in: &bag)
    }
    
    func deleteClothes(_ id: String, completion: @escaping () -> Void) {
        closetService.deleteClothes(id: id)
            .sink { event in
                print("ClothesDetail:", event)
            } receiveValue: { _ in
                self.resetCloset()
                completion()
            }.store(in: &bag)
    }
    
    func checkInviteCode(_ code: String, completion: @escaping (Bool) -> Void) {
        closetService.clothesInviteList(
            parameters: ["inviteCode": code, "page": 0, "size": 1]
        ).sink { event in
            switch event {
            case .finished:
                print("CheckInviteCode:", event)
            case .failure:
                completion(false)
            }
        } receiveValue: { _ in
            completion(true)
        }.store(in: &bag)
    }
    
}

extension ClosetViewModel {
    
    struct State {
        var userProfile: UserProfileEntity?
        var clothes: [ClothesEntity] = []
        var parsedClothes: (ClothesRegisterEntity, Data)?
        
        var filter: ClothesFilter = .init()
    }
    
    enum Action {
        case onAppear
        case fetchClothesList
        case selectFilter(ClothesFilter)
        case refresh
    }
    
}
