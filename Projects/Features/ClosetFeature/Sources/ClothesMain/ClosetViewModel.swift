//
//  ClosetViewModel.swift
//  neggu
//
//  Created by 유지호 on 2/5/25.
//

import Core
import Domain

import BaseFeature
import ClosetFeatureInterface

import UIKit
import Combine
import SwiftSoup

public final class ClosetViewModel: ObservableObject {
    
    // MARK: Input
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let closetDidScroll = PassthroughSubject<Void, Never>()
    let closetDidRefresh = PassthroughSubject<Void, Never>()
    let filterDidSelect = PassthroughSubject<ClothesFilter, Never>()
    let urlDidParse = PassthroughSubject<String, Never>()
    
    // MARK: Output
    @Published private(set) var clothesList: [ClothesEntity] = []
    
    private var filter: ClothesFilter = .init()
    
    private let router: ClosetRoutable
    private let closetUsecase: any ClosetUsecase
    
    private var bag = Set<AnyCancellable>()
    
    public init(
        router: ClosetRoutable,
        closetUsecase: any ClosetUsecase
    ) {
        self.router = router
        self.closetUsecase = closetUsecase
        
        bind()
        print("\(self) init")
    }
    
    deinit {
        bag.removeAll()
        print("\(self) deinit")
    }
    
    
    private func bind() {
        viewDidAppear
            .filter { _ in self.clothesList.isEmpty }
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchClothes()
            }.store(in: &bag)
        
        closetDidScroll
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                owner.fetchClothes()
            }.store(in: &bag)
        
        closetDidRefresh
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                owner.closetUsecase.resetClothesList()
                owner.fetchClothes()
            }.store(in: &bag)
        
        filterDidSelect
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, filter in
                owner.closetUsecase.resetClothesList()
                owner.filter = filter
                owner.fetchClothes()
            }.store(in: &bag)
        
        urlDidParse
            .withUnretained(self)
            .sink { owner, urlString in
                owner.parseHTML(link: urlString)
            }.store(in: &bag)
        
        closetUsecase.clothesList
            .assign(to: \.clothesList, on: self)
            .store(in: &bag)
    }
    
    private func fetchClothes() {
        var parameters: [String: Any] = [:]
        
        if filter.subCategory == .UNKNOWN {
            if filter.category != .UNKNOWN {
                parameters["category"] = filter.category.id
            }
        } else {
            parameters["subCategory"] = filter.subCategory.id
        }
        
        if !filter.moodList.isEmpty {
            parameters["mood"] = filter.moodList[0].id
        }
        
        closetUsecase.fetchClothesList(parameters: parameters)
    }
    
    public func presentDetail(id: String) {
        router.presentDetail(id: id)
    }
    
    public func pushRegister(image: UIImage, clothes: ClothesRegisterEntity) {
        router.routeToRegister(image, clothes)
    }
    
    private func parseHTML(link: String) {
        Task {
            do {
                let htmlString = try await convertURLToHTMLString(urlString: link)
                let jsonData = try convertHTMLToJSON(from: htmlString, urlString: link)
                let product = try decodeProduct(data: jsonData, urlString: link)
                let convertedProduct = product.toProduct(urlString: link)
                
                guard let imageUrl = URL(string: product.imageUrl),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl)
                else {
                    throw NSError(domain: "Failed to parse product.", code: 3)
                }
                
                guard let image = await ImageAnalyzeManager.shared.segmentation(imageData)
                else {
                    throw NSError(domain: "No Image", code: 4)
                }
                
                await MainActor.run {
                    pushRegister(image: image, clothes: convertedProduct)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func convertURLToHTMLString(urlString: String) async throws -> String {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid url", code: 0)
        }
        
        var request = URLRequest(url: url)
        // 모바일 기기의 경우 랜딩 페이지로 이동하기 때문에 웹으로 들어간 것으로 처리해야함
        request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        guard let htmlString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "Failed to get HTML content", code: 1)
        }
        
        return htmlString
    }
    
    private func convertHTMLToJSON(from html: String, urlString: String) throws -> Data {
        let document = try SwiftSoup.parse(html)
        let type = urlString.contains("kream") ? "ld+json" : "json"
        let scripts = try document.select("script[type=application/\(type)]")
        
        for script in scripts {
            let jsonString = try script.html()
            
            if let data = jsonString.data(using: .utf8) {
                return data
            }
        }
        
        throw NSError(domain: "Failed to get JSON", code: 1)
    }
    
    private func decodeProduct(data: Data, urlString: String) throws -> Clothesable {
        switch urlString {
        case _ where urlString.contains("kream"):
            return try JSONDecoder().decode(KreamProduct.self, from: data)
        case _ where urlString.contains("musinsa"):
            return try JSONDecoder().decode(MusinsaProduct.self, from: data)
        case _ where urlString.contains("zigzag"):
            return try JSONDecoder().decode(ZigzagProduct.self, from: data)
        case _ where urlString.contains("a-bly"):
            return try JSONDecoder().decode(AblyProduct.self, from: data)
        case _ where urlString.contains("queenit."):
            return try JSONDecoder().decode(QueenitProduct.self, from: data)
        case _ where urlString.contains("29cm."):
            return try JSONDecoder().decode(TwentyNineCMProduct.self, from: data)
        default:
            throw NSError(domain: "Failed to decode data.", code: 2)
        }
    }
    
}
