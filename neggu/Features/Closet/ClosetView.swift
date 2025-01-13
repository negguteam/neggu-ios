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
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(.negguLogo)
                
                Spacer()
            }
            .frame(height: 68)
            .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 20) {
                        HStack {
                            Image(.link)
                            
                            TextField(
                                "",
                                text: $clothesURLString,
                                prompt: Text("링크를 입력해 옷장에 담아보세요!").foregroundStyle(.labelAssistive)
                            )
                            .focused($isFocused)
                            
                            Button("완료") {
                                if clothesURLString.isEmpty { return }
                                Task { await segmentation() }
                            }
                        }
                        .negguFont(.body2)
                        .foregroundStyle(.labelAssistive)
                        .padding(.horizontal)
                        .padding(.vertical, 18)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .foregroundStyle(.bgAlt)
                        }
                        
                        BannerCarousel()
                            .padding(.horizontal, -20)
                    }
                    .id(0)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("내 옷장")
                            .negguFont(.title2)
                            .foregroundStyle(.labelNormal)
                            .padding(.horizontal, 8)
                        
                        HStack {
                            ForEach(0..<3, id: \.self) { _ in
                                HStack {
                                    Text("카테고리")
                                    
                                    Image(systemName: "chevron.down")
                                }
                                .negguFont(.body3b)
                                .foregroundStyle(.labelAssistive)
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.bgAlt)
                                }
                            }
                        }
                        .frame(height: 50)
                        .padding(.vertical, 8)
                        
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
                                            .aspectRatio(9/11, contentMode: .fit)
                                            .overlay {
                                                Image("dummy_clothes\(index % 3)")
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                    }
                                }
                            }
                        }
                        .scrollIndicators(.hidden)
                        .scrollDisabled(scrollPosition == 0)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 20)
                        .background {
                            RoundedRectangle(cornerRadius: 32)
                                .fill(.white)
                        }
                    }
                    .containerRelativeFrame(.vertical)
                    .id(1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollPosition)
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
            .overlay(alignment: .bottom) {
                Button {
                    closetCoordinator.fullScreenCover = .lookbookEdit
                } label: {
                    Text("네가 좀 꾸며줘! ✨")
                        .negguFont(.body2b)
                        .foregroundStyle(.white)
                        .frame(height: 44)
                        .padding(.horizontal)
                        .background {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.negguSecondary)
                                .shadow(
                                    color: .black.opacity(0.05),
                                    radius: 4,
                                    x: 4,
                                    y: 4
                                )
                                .shadow(
                                    color: .black.opacity(0.1),
                                    radius: 10,
                                    y: 4
                                )
                        }
                }
                .opacity(scrollPosition == 0 ? 0 : 1)
                .offset(y: scrollPosition == 0 ? 0 : -86)
                .animation(.smooth, value: scrollPosition)
            }
        }
        .background {
            Color(.bgNormal)
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
        }
    }
    
    private func segmentation() async {
        var urlString = clothesURLString
        
        if urlString.contains("a-bly") {
            urlString = urlString.replacingOccurrences(of: "a-bly.com/app", with: "m.a-bly.com")
        }
        
        guard let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        
        if urlString.contains("kream") || urlString.contains("goodw") {
            request.setValue("iPhone", forHTTPHeaderField: "User-Agent")
        } else {
            request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("Failed to get HTML content")
                return
            }
            
            let document = try SwiftSoup.parse(htmlString)
            
            let scriptElements = try document.select("script[type=application/\(urlString.contains("a-bly") || urlString.contains("queenit.kr") || urlString.contains("29cm.") || urlString.contains("musinsaapp") || urlString.contains("zigzag")  ? "" : "ld+")json]")
            
            for element in scriptElements {
                let jsonString = try element.html()//.replacingOccurrences(of: "\"\"", with: "\"")
                
                guard let data = jsonString.data(using: .utf8) else { return }
                
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                
                let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
                print(attributedString)
                print()
                
                guard let parsedData = attributedString.string.data(using: .utf8) else { return }
                var product: Clothesable?
                
                if urlString.contains("kream") {
                    product = try? JSONDecoder().decode(KreamProduct.self, from: parsedData)
                } else if urlString.contains("musinsa") {
                    product = try? JSONDecoder().decode(MusinsaProduct.self, from: parsedData)
                } else if urlString.contains("zigzag") {
                    product = try? JSONDecoder().decode(ZigzagProduct.self, from: parsedData)
                } else if urlString.contains("a-bly") {
                    product = try? JSONDecoder().decode(AblyProduct.self, from: parsedData)
                } else if urlString.contains("queenit.") {
                    product = try? JSONDecoder().decode(QueenitProduct.self, from: parsedData)
                } else if urlString.contains("29cm.") {
                    product = try? JSONDecoder().decode(TwentyNineCMProduct.self, from: parsedData)
                } else {
                    product = nil
                }
                
                guard let convertedProduct = product?.toProduct(urlString: urlString),
                      let imageUrl = URL(string: convertedProduct.imageUrl),
                      let (imageData, _) = try? await URLSession.shared.data(from: imageUrl),
                      let image = UIImage(data: imageData),
                      let segmentedImage = await ImageAnalyzeManager.shared.segmentation(image)
                else {
                    // 시뮬레이터는 segmentation을 지원하지 않아서 테스트를 위한 임시 처리
                    let clothes = Clothes(
                        name: "루즈핏 V넥 베스트 CRYSTAL BEIGE",
                        link:  "https://musinsaapp.page.link/v1St9cWw5h291zfBA",
                        imageUrl: "https://image.msscdn.net/images/goods_img/20230809/3454995/3454995_16915646154097_500.jpg",
                        brand: "내셔널지오그래픽"
                    )
                    
                    await MainActor.run {
                        closetCoordinator.fullScreenCover = .closetAdd(clothes: clothes, segmentedImage: .dummyClothes1)
                    }
                    
                    return
                }
                
                await MainActor.run {
                    let clothes = Clothes(
                        name: convertedProduct.name,
                        link: convertedProduct.link,
                        imageUrl: convertedProduct.imageUrl,
                        brand: convertedProduct.brand
                    )
                    
                    closetCoordinator.fullScreenCover = .closetAdd(clothes: clothes, segmentedImage: segmentedImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
