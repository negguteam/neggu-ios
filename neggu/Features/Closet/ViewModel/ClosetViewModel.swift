//
//  ClosetViewModel.swift
//  neggu
//
//  Created by 유지호 on 2/5/25.
//

import Foundation
import Combine
import SwiftSoup

final class ClosetViewModel: ObservableObject {
    
    private let userService: any UserService
    private let closetService: any ClosetService
    
    private let input = PassthroughSubject<Action, Never>()
    
    @Published private(set) var output = State()
    
    private var page: Int = 0
    private var canPagenation: Bool = true
    
    private var bag = Set<AnyCancellable>()
    
    
    init(
        userService: any UserService,
        closetService: any ClosetService
    ) {
        self.closetService = closetService
        self.userService = userService

//        fetchUserProfile()
        
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
        case .fetchClothesList:
            getClothes()
        case .selectFilter(let filter):
            filteredClothes(filter: filter)
        case .refresh:
            resetCloset()
        case .parseHTML(let link, let completion):
            Task {
                await parseHTML(link: link)
                completion()
            }
        }
    }
        
    func fetchUserProfile() {
        userService.profile()
            .sink { event in
                print("ClosetView:", event)
            } receiveValue: { [weak self] profile in
                self?.output.userProfile = profile
            }.store(in: &bag)
    }
    
    func getClothes() {
        if !canPagenation { return }
        canPagenation = false
        
        var parameters: [String: Any] = ["page": page, "size": 18]
        
        let category = output.filter.category
        let subCategory = output.filter.subCategory
        let mood = output.filter.moodList
        let color = output.filter.color
        
        if subCategory == .UNKNOWN {
            if category != .UNKNOWN {
                parameters["category"] = category.id
            }
        } else {
            parameters["subCategory"] = subCategory.id
        }
        
        if !mood.isEmpty {
            parameters["mood"] = mood[0].id
        }
        
        if let color {
            parameters["colorGroup"] = color.id
        }
        
        closetService.clothesList(parameters: parameters)
            .sink { event in
                print("ClosetView:", event)
            } receiveValue: { [weak self] result in
                self?.canPagenation = !result.last
                self?.output.clothes += result.content
                self?.page += !result.last ? 1 : 0
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
    
    private func parseHTML(link: String) async {
        do {
            guard let url = URL(string: link) else {
                throw NSError(domain: "Invalid url", code: 1)
            }
            
            var request = URLRequest(url: url)
            
            // 지그재그의 경우 랜딩 페이지로 이동하기 때문에 웹으로 들어간 것으로 처리해야함
            if link.contains("zigzag") {
                request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
            } else {
                request.setValue(Util.deviceName, forHTTPHeaderField: "User-Agent")
            }
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "Failed to get HTML content", code: 2)
            }
            
            let document = try SwiftSoup.parse(htmlString)
            
            // 무신사, 에이블리, 지그재그, 29cm, 퀸잇 -> application/json
            // 크림 -> application/ld+json
            let scriptElements = link.contains("kream")
            ? try document.select("script[type=application/ld+json]")
            : try document.select("script[type=application/json]")
            
            for element in scriptElements {
                let jsonString = try element.html()
                
                guard let data = jsonString.data(using: .utf8) else {
                    throw NSError(domain: "Failed to get JSON data", code: 3)
                }
                
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                debugPrint(attributedString)
                
                guard let parsedData = attributedString.string.data(using: .utf8) else {
                    throw NSError(domain: "Failed to get parsed data", code: 4)
                }
                
                var product: Clothesable?
                
                switch link {
                case _ where link.contains("kream"):
                    product = try? JSONDecoder().decode(KreamProduct.self, from: parsedData)
                case _ where link.contains("musinsa"):
                    product = try? JSONDecoder().decode(MusinsaProduct.self, from: parsedData)
                case _ where link.contains("zigzag"):
                    product = try? JSONDecoder().decode(ZigzagProduct.self, from: parsedData)
                case _ where link.contains("a-bly"):
                    product = try? JSONDecoder().decode(AblyProduct.self, from: parsedData)
                case _ where link.contains("queenit."):
                    product = try? JSONDecoder().decode(QueenitProduct.self, from: parsedData)
                case _ where link.contains("29cm."):
                    product = try? JSONDecoder().decode(TwentyNineCMProduct.self, from: parsedData)
                default:
                    product = nil
                }
                
                guard let convertedProduct = product?.toProduct(urlString: link),
                      let imageUrl = URL(string: product?.imageUrl ?? ""),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl)
                else { continue }
                
                await MainActor.run {
                    output.parsingResult = .init(clothes: convertedProduct, imageData: imageData)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
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
        var parsingResult: HTMLParsingResult?
        var filter: ClothesFilter = .init()
    }
    
    enum Action {
        case fetchClothesList
        case selectFilter(ClothesFilter)
        case refresh
        case parseHTML(String, completion: () -> Void)
    }
    
}
