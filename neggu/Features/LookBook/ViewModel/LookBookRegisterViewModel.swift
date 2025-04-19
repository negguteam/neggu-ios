//
//  LookBookRegisterViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//


import Foundation
import Combine

final class LookBookRegisterViewModel: ObservableObject {

    private let closetService: ClosetService
    private let lookBookService: LookBookService
//    private let userService: UserService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var page: Int = 0
    private var canPagenation: Bool = true
    
    private var bag = Set<AnyCancellable>()
    
    
    init(
        closetService: ClosetService = DefaultClosetService(),
        lookBookService: LookBookService = DefaultLookBookService()
    ) {
        self.closetService = closetService
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
        case .fetchClothes(let inviteCode):
            getClothes(inviteCode: inviteCode)
        case .onTapCategory(let category, let inviteCode):
            if category == output.selectedCategory { return }
            output.selectedCategory = category
            resetLookBookClothes()
            getClothes(inviteCode: inviteCode)
        case .onTapColor(let colorFilter, let inviteCode):
            if colorFilter == output.selectedColor { return }
            output.selectedColor = colorFilter
            resetLookBookClothes()
            getClothes(inviteCode: inviteCode)
        case .onTapRegister(let image, let clothes, let inviteCode, let completion):
            let request = clothes.compactMap { $0.toEntity() }
            register(image: image, request: request, inviteCode: inviteCode, completion: completion)
        }
    }
    
    private func register(
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
        
    private func getClothes(inviteCode: String) {
        if !canPagenation { return }
        canPagenation = false
        
        var parameters: [String: Any] = ["page": page, "size": 6]
        
        if output.selectedCategory != .UNKNOWN && output.selectedCategory != .NONE {
            parameters["filterCategory"] = output.selectedCategory.id
        }
        
        parameters["colorGroup"] = output.selectedColor == nil ? "ALL" : output.selectedColor!.id
        
        if inviteCode.isEmpty {
            lookBookService.lookbookClothes(parameters: parameters)
                .sink { event in
                    print("LookBookRegisterView:", event)
                } receiveValue: { [weak self] result in
                    self?.canPagenation = !result.last
                    self?.page += result.last ? 0 : 1
                    self?.output.clothes += result.content
                }.store(in: &bag)
        } else {
            closetService.clothesInviteList(parameters: parameters)
                .sink { event in
                    print("LookBookRegisterView:", event)
                } receiveValue: { [weak self] result in
                    self?.canPagenation = !result.last
                    self?.page += result.last ? 0 : 1
                    self?.output.clothes += result.content
                }.store(in: &bag)
        }
    }
    
    private func resetLookBookClothes() {
        page = 0
        canPagenation = true
        output.clothes.removeAll()
    }
    
}


extension LookBookRegisterViewModel {
    
    struct State {
        var clothes: [ClothesEntity] = []
        var editingClothes: LookBookClothesItem?
        var selectedCategory: Category = .NONE
        var selectedColor: ColorFilter?
    }
    
    enum Action {
        case fetchClothes(inviteCode: String = "")
        case onTapCategory(Category, inviteCode: String = "")
        case onTapColor(ColorFilter?, inviteCode: String = "")
        case onTapRegister(image: Data, clothes: [LookBookClothesItem], inviteCode: String = "", completion: () -> Void)
    }
    
}
