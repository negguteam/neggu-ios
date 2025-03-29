//
//  ClosetViewModel.swift
//  neggu
//
//  Created by 유지호 on 2/5/25.
//

import Foundation
import Combine

final class ClosetViewModel: ObservableObject {
    
    @Published var clothes: [ClothesEntity] = []
    
    @Published var selectedCategory: Category = .UNKNOWN
    @Published var selectedSubCategory: SubCategory = .UNKNOWN
    @Published var selectedMood: [Mood] = []
    @Published var selectedColor: ColorFilter?
    
    @Published var page: Int = 0
    @Published var canPagenation: Bool = true
    
    private let closetService = DefaultClosetService()
    
    var bag = Set<AnyCancellable>()
    
    init() {
        filteredClothes()
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
            self.refreshCloset()
            completion()
        }.store(in: &bag)
    }
    
    func getClothes() {
        if !canPagenation { return }
        
        var parameters: [String: Any] = ["page": page, "size": 9]
        
        if selectedSubCategory == .UNKNOWN {
            if selectedCategory != .UNKNOWN {
                parameters["category"] = selectedCategory.id
            }
        } else {
            parameters["subCategory"] = selectedSubCategory.id
        }
        
        if !selectedMood.isEmpty {
            parameters["mood"] = selectedMood[0].id
        }
        
        if let color = selectedColor {
            parameters["colorGroup"] = color.id
        }
        
        closetService.clothesList(parameters: parameters)
            .sink { event in
                print("ClosetView:", event)
            } receiveValue: { result in
                self.clothes += result.content
                
                if !result.last {
                    self.page += 1
                }
                
                self.canPagenation = !result.last
            }.store(in: &bag)
    }
    
    func filteredClothes() {
        $selectedCategory.combineLatest($selectedSubCategory, $selectedMood, $selectedColor)
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] _, _, _, _ in
                self?.resetPage()
                self?.clothes.removeAll()
                self?.getClothes()
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
                self.refreshCloset()
                completion()
            }.store(in: &bag)
    }
    
    func refreshCloset() {
        resetPage()
        clothes.removeAll()
        getClothes()
    }
    
    func resetPage() {
        page = 0
        canPagenation = true
    }
    
    func resetFilter() {
        selectedCategory = .UNKNOWN
        selectedSubCategory = .UNKNOWN
        selectedColor = nil
        selectedMood.removeAll()
    }
    
}
