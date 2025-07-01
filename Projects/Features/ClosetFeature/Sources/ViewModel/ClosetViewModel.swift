//
//  ClosetViewModel.swift
//  neggu
//
//  Created by 유지호 on 2/5/25.
//

import Core
import Networks

import BaseFeature

import Foundation
import Combine
import SwiftSoup

public final class ClosetViewModel: ObservableObject {
    
    // MARK: Input
    let closetDidScroll = PassthroughSubject<Void, Never>()
    let closetDidRefresh = PassthroughSubject<Void, Never>()
    let filterDidSelect = PassthroughSubject<ClothesFilter, Never>()
    let urlDidParse = PassthroughSubject<String, Never>()
    
    // MARK: Output
    @Published private(set) var clothesList: [ClothesEntity] = []
    @Published private(set) var filter: ClothesFilter = .init()
    @Published private(set) var parsingResult: HTMLParsingResult?
    @Published private(set) var isLoading: Bool = false
    
    private var page: Int = 0
    
    private let closetUsecase: any ClosetUsecase
    
    private var bag = Set<AnyCancellable>()
    
    public init(closetUsecase: any ClosetUsecase) {
        self.closetUsecase = closetUsecase
        
        bind()
    }
    
    deinit {
        bag.removeAll()
    }
    
    
    private func bind() {
        closetDidScroll
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .filter { _ in !self.isLoading }
            .withUnretained(self)
            .sink { owner, _ in
                owner.isLoading = true
                owner.fetchClothes()
            }.store(in: &bag)
        
        closetDidRefresh
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .withUnretained(self)
            .sink { owner, _ in
                owner.isLoading = false
                owner.page = 0
                owner.clothesList = []
                owner.fetchClothes()
            }.store(in: &bag)
        
        filterDidSelect
            .throttle(for: .seconds(0.5), scheduler: RunLoop.main, latest: false)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, filter in
                owner.filter = filter
                owner.fetchClothes()
            }.store(in: &bag)
        
        urlDidParse
            .withUnretained(self)
            .sink { owner, urlString in
                Task { await owner.parseHTML(link: urlString) }
            }.store(in: &bag)
        
        closetUsecase.clothesList
            .withUnretained(self)
            .sink { owner, clothesList in
                guard !clothesList.isEmpty else { return }
                owner.isLoading = false
                owner.clothesList += clothesList
                owner.page += 1
            }.store(in: &bag)
    }
    
    private func fetchClothes() {
        var parameters: [String: Any] = ["page": page, "size": 18]
        
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
        
        if let color = filter.color {
            parameters["colorGroup"] = color.id
        }
        
        isLoading = true
        closetUsecase.fetchClothesList(parameters: parameters)
    }
    
    private func parseHTML(link: String) async {
        do {
            guard let url = URL(string: link) else {
                throw NSError(domain: "Invalid url", code: 1)
            }
            
            var request = URLRequest(url: url)
            
            // 모바일 기기의 경우 랜딩 페이지로 이동하기 때문에 웹으로 들어간 것으로 처리해야함
//            if link.contains("musinsa") || link.contains("zigzag") {
                request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
//            } else {
//                request.setValue(Util.deviceName, forHTTPHeaderField: "User-Agent")
//            }
            
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
                    parsingResult = .init(clothes: convertedProduct, imageData: imageData)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func checkInviteCode(_ code: String, completion: @escaping (Bool) -> Void) {
//        closetService.clothesInviteList(
//            parameters: ["inviteCode": code, "page": 0, "size": 1]
//        ).sink { event in
//            switch event {
//            case .finished:
//                print("CheckInviteCode:", event)
//            case .failure:
//                completion(false)
//            }
//        } receiveValue: { _ in
//            completion(true)
//        }.store(in: &bag)
//    }
    
}
