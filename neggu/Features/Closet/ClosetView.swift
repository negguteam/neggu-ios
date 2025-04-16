//
//  ClosetView.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI
import SwiftSoup
import Combine

struct ClosetView: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @StateObject private var viewModel = ClosetViewModel()
    
    @State private var clothesURLString: String = ""
    @State private var scrollPosition: Int? = 0
    
    @State private var filter: ClothesFilter = .init()
    
    @State private var showCategoryFilter: Bool = false
    @State private var showMoodFilter: Bool = false
    @State private var showColorFilter: Bool = false
    @State private var ctaButtonExpanded: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                LinkBanner(urlString: $clothesURLString) {
                    if clothesURLString.isEmpty { return }
                    clothesURLString = clothesURLString.split(separator: " ").filter { $0.contains("https://") }.joined()
                    
                    Task {
                        await segmentation()
                        clothesURLString.removeAll()
                        isFocused = false
                    }
                    
                }
                .focused($isFocused)
                .id(0)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("내 옷장")
                        .negguFont(.title2)
                        .foregroundStyle(.labelNormal)
                    
                    HStack {
                        FilterButton(title: filter.categoryTitle) {
                            showCategoryFilter = true
                        }
                        
                        FilterButton(title: filter.moodTitle) {
                            showMoodFilter = true
                        }
                        
                        FilterButton(title: filter.colorTitle) {
                            showColorFilter = true
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(.flexible(), spacing: 18), count: 3),
                            spacing: 16
                        ) {
                            ForEach(viewModel.output.clothes) { item in
                                Button {
                                    coordinator.sheet = .clothesDetail(clothesID: item.id)
                                } label: {
                                    Rectangle()
                                        .fill(.clear)
                                        .aspectRatio(5/6, contentMode: .fit)
                                        .overlay {
                                            CachedAsyncImage(item.imageUrl)
                                        }
                                }
                            }
                            
                            Rectangle()
                                .fill(.clear)
                                .frame(height: 56)
                                .onAppear {
                                    viewModel.send(action: .fetchClothesList)
                                }
                        }
                        .padding(.bottom, viewModel.output.clothes.count % 3 == 0 ? 24 : 80)
                    }
                    .scrollIndicators(.hidden)
                    .scrollDisabled(scrollPosition == 0)
                    .padding(.horizontal, 12)
                }
                .containerRelativeFrame(.vertical)
                .id(1)
            }
            .scrollTargetLayout()
            .padding(.horizontal, 20)
            .padding(.top, 28)
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollPosition)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.immediately)
        .padding(.top, 1)
        .overlay {
            if ctaButtonExpanded {
                Color.bgDimmed
                    .ignoresSafeArea()
                    .onTapGesture {
                        ctaButtonExpanded = false
                    }
            }
        }
        .overlay(alignment: .bottom) {
            NegguCTAButton(isExpanded: $ctaButtonExpanded)
                .opacity(scrollPosition == 0 ? 0 : 1)
                .offset(y: scrollPosition == 0 ? 0 : -78)
                .animation(.smooth, value: scrollPosition)
                .animation(.smooth(duration: 0.3), value: ctaButtonExpanded)
        }
        .background {
            Color.bgNormal
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        }
        .refreshable {
            filter = .init()
            viewModel.send(action: .refresh)
        }
        .sheet(isPresented: $showCategoryFilter) {
            CategorySheet(
                selectedCategory: $filter.category,
                selectedSubCategory: $filter.subCategory
            )
            .presentationDetents([.fraction(0.85)])
        }
        .sheet(isPresented: $showMoodFilter) {
//            MoodSheet(selectedMoodList: $filter.mood, isSingleSelection: true)
//                .presentationDetents([.fraction(0.85)])
        }
        .sheet(isPresented: $showColorFilter) {
            ColorSheet(selectedColor: $filter.color)
                .presentationDetents([.fraction(0.85)])
        }
        .onChange(of: filter) { _, newValue in
            viewModel.send(action: .selectFilter(newValue))
        }
    }
    
    private func segmentation() async {
        let urlString = clothesURLString
        
        guard let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        
        // 지그재그의 경우 랜딩 페이지로 이동하기 때문에 웹으로 들어간 것으로 처리해야함
        switch urlString {
        case _ where urlString.contains("zigzag"):
            request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
        default:
            request.setValue(UIDevice.current.name, forHTTPHeaderField: "User-Agent")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("Failed to get HTML content")
                return
            }
            
            let document = try SwiftSoup.parse(htmlString)
            
            // 무신사, 에이블리, 지그재그, 29cm, 퀸잇 -> application/json
            // 크림 -> application/ld+json
            let scriptElements =
            switch urlString {
            case _ where urlString.contains("kream"):
                try document.select("script[type=application/ld+json]")
            default:
                try document.select("script[type=application/json]")
            }
            
            for element in scriptElements {
                let jsonString = try element.html()
                
                guard let data = jsonString.data(using: .utf8) else { return }
                
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                debugPrint(attributedString)
                
                guard let parsedData = attributedString.string.data(using: .utf8) else { return }
                var product: Clothesable?
                
                switch urlString {
                case _ where urlString.contains("kream"):
                    product = try? JSONDecoder().decode(KreamProduct.self, from: parsedData)
                case _ where urlString.contains("musinsa"):
                    product = try? JSONDecoder().decode(MusinsaProduct.self, from: parsedData)
                case _ where urlString.contains("zigzag"):
                    product = try? JSONDecoder().decode(ZigzagProduct.self, from: parsedData)
                case _ where urlString.contains("a-bly"):
                    product = try? JSONDecoder().decode(AblyProduct.self, from: parsedData)
                case _ where urlString.contains("queenit."):
                    product = try? JSONDecoder().decode(QueenitProduct.self, from: parsedData)
                case _ where urlString.contains("29cm."):
                    product = try? JSONDecoder().decode(TwentyNineCMProduct.self, from: parsedData)
                default:
                    product = nil
                }
                
                guard let convertedProduct = product?.toProduct(urlString: urlString),
                      let imageUrl = URL(string: product?.imageUrl ?? ""),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl),
                      let image = UIImage(data: imageData),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(image)
                else {
                    continue
                }
                
                await MainActor.run {
                    coordinator.fullScreenCover = .closetAdd(clothes: convertedProduct, segmentedImage: segmentedImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
