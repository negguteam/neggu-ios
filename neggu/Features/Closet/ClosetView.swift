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
    @EnvironmentObject private var closetCoordinator: MainCoordinator
    @EnvironmentObject private var viewModel: ClosetViewModel
    
    @State private var clothesURLString: String = ""
    @State private var scrollPosition: Int? = 0
    
    @FocusState private var isFocused: Bool
    @State private var filterType: FilterType?
    @State private var selectedClothes: ClothesEntity?
    
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
                        FilterButton(title: categoryTitle) {
                            filterType = .category
                        }
                        
                        FilterButton(title: moodTitle) {
                            filterType = .mood
                        }
                        
                        FilterButton(title: colorTitle) {
                            filterType = .color
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 24)
                    
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem](repeating: GridItem(.flexible(), spacing: 18), count: 3),
                            spacing: 16
                        ) {
                            ForEach(viewModel.clothes) { item in
                                Button {
                                    selectedClothes = item
                                } label: {
                                    Rectangle()
                                        .fill(.clear)
                                        .aspectRatio(5/6, contentMode: .fit)
                                        .overlay {
                                            AsyncImage(url: URL(string: item.imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(.clear)
                            .frame(height: 56)
                            .onAppear {
                                if viewModel.page <= 0 { return }
                                viewModel.getClothes()
                            }
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
        .overlay(alignment: .bottom) {
            Button {
                
            } label: {
                NegguCTAButton()
            }
            .opacity(scrollPosition == 0 ? 0 : 1)
            .offset(y: scrollPosition == 0 ? 0 : -84)
            .animation(.smooth, value: scrollPosition)
        }
        .padding(.top, 1)
        .background {
            Color.bgNormal
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        }
        .refreshable {
            viewModel.resetFilter()
            viewModel.refreshCloset()
        }
        .sheet(item: $selectedClothes) { clothes in
            ClothesDetailView(clothesID: clothes.id)
                .presentationDetents([.fraction(0.9)])
                .presentationCornerRadius(20)
        }
        .sheet(item: $filterType) { filterType in
            switch filterType {
            case .category:
                CategorySheet(
                    selectedCategory: $viewModel.selectedCategory,
                    selectedSubCategory: $viewModel.selectedSubCategory
                )
                .presentationDetents([.fraction(0.85)])
            case .mood:
                MoodSheet(selectedMoodList: $viewModel.selectedMood, isSingleSelection: true)
                    .presentationDetents([.fraction(0.85)])
            case .color:
                ColorSheet(selectedColor: $viewModel.selectedColor)
                    .presentationDetents([.fraction(0.85)])
            }
        }
    }
    
    
    var categoryTitle: String {
        if viewModel.selectedSubCategory != .UNKNOWN {
            viewModel.selectedSubCategory.title
        } else if viewModel.selectedCategory != .UNKNOWN {
            viewModel.selectedCategory.title
        } else {
            "카테고리"
        }
    }
    
    var moodTitle: String {
        if let firstMood = viewModel.selectedMood.first {
            firstMood.title
        } else {
            "분위기"
        }
    }
    
    var colorTitle: String {
        viewModel.selectedColor?.id.uppercased() ?? "색상"
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
                      let imageUrl = URL(string: convertedProduct.imageUrl),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl),
                      let image = UIImage(data: imageData),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(image)
                else {
                    // 시뮬레이터는 segmentation을 지원하지 않아서 테스트를 위한 임시 처리
//                    let clothes = ClothesRegisterEntity(
//                        name: "루즈핏 V넥 베스트 CRYSTAL BEIGE",
//                        brand: "내셔널지오그래픽",
//                        link:  "https://musinsaapp.page.link/v1St9cWw5h291zfBA"
//                        imageUrl: "https://image.msscdn.net/images/goods_img/20230809/3454995/3454995_16915646154097_500.jpg",
//                    )
//                    
//                    await MainActor.run {
//                        closetCoordinator.fullScreenCover = .closetAdd(clothes: clothes, segmentedImage: .dummyClothes1)
//                    }
//                    
//                    print("시뮬레이터 세그먼테이션 이슈")
                    continue
                }
                
                await MainActor.run {
                    let clothes = ClothesRegisterEntity(
                        name: convertedProduct.name,
                        brand: convertedProduct.brand,
                        link: convertedProduct.link
                    )
                    
                    closetCoordinator.fullScreenCover = .closetAdd(clothes: clothes, segmentedImage: segmentedImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func testSegmentation() {
        let image = UIImage(resource: .bannerBG1)
        let clothes: ClothesRegisterEntity = .mockData
        
        closetCoordinator.fullScreenCover = .closetAdd(clothes: clothes, segmentedImage: image)
    }
    
    enum FilterType: Identifiable {
        case category
        case mood
        case color
        
        var id: String { "\(self)" }
    }
}

//#Preview {
//    ContentView()
//}
