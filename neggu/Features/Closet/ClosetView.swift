//
//  ClosetView.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI
import SwiftSoup

struct ClosetView: View {
    @EnvironmentObject private var closetCoordinator: MainCoordinator
    
    @State private var clothesURLString: String = ""
    @State private var scrollPosition: Int? = 0
    
    @State private var selectedCategory: Category?
    @State private var selectedSubCategory: SubCategory?
    @State private var selectedColor: ColorFilter?
    
    @FocusState private var isFocused: Bool
    @State private var filterType: FilterType?
    
    @State private var categoryFilterSheetHeight: CGFloat = .zero
    
    var categoryTitle: String {
        selectedSubCategory?.rawValue ?? selectedCategory?.rawValue ?? "카테고리"
    }
    
    var colorTitle: String {
        selectedColor?.id.uppercased() ?? "색상"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 48) {
                LinkBanner(urlString: $clothesURLString) {
                    if clothesURLString.isEmpty { return }
                    clothesURLString = clothesURLString.split(separator: " ").filter { $0.contains("https://") }.joined()
                    Task { await segmentation() }
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
                        
                        FilterButton(title: "분위기") {
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
                            ForEach(0...20, id: \.self) { index in
                                Button {
                                    let clothes = Clothes(
                                        name: "멋진 옷",
                                        link: "www.neggu.com",
                                        imageUrl: "",
                                        brand: "넦"
                                    )
                                    
                                    closetCoordinator.push(.clothesDetail(clothes: clothes))
                                } label: {
                                    Rectangle()
                                        .fill(.clear)
                                        .aspectRatio(5/6, contentMode: .fit)
                                        .overlay {
                                            Image("dummy_clothes\(index % 3)")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                }
                            }
                        }
                        .padding(.bottom, 64)
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
                closetCoordinator.fullScreenCover = .lookbookEdit
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
        .sheet(item: $filterType) { filterType in
            switch filterType {
            case .category:
                CategorySheet(
                    selectedCategory: $selectedCategory,
                    selectedSubCategory: $selectedSubCategory
                )
                .presentationDetents([.fraction(0.85)])
            case .mood:
                Text("필터")
                    .presentationDetents([.fraction(0.85)])
            case .color:
                ColorSheet(selectedColor: $selectedColor)
                    .presentationDetents([.fraction(0.85)])
            }
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
                      let imageUrl = URL(string: convertedProduct.imageUrl),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl),
                      let image = UIImage(data: imageData),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(image)
                else {
                    // 시뮬레이터는 segmentation을 지원하지 않아서 테스트를 위한 임시 처리
//                    let clothes = Clothes(
//                        name: "루즈핏 V넥 베스트 CRYSTAL BEIGE",
//                        link:  "https://musinsaapp.page.link/v1St9cWw5h291zfBA",
//                        imageUrl: "https://image.msscdn.net/images/goods_img/20230809/3454995/3454995_16915646154097_500.jpg",
//                        brand: "내셔널지오그래픽"
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
    
    enum FilterType: Identifiable {
        case category
        case mood
        case color
        
        var id: String { "\(self)" }
    }
}

#Preview {
    ContentView()
}
