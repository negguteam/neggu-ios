//
//  ClosetView.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import SwiftUI
import SwiftSoup

struct ClosetView: View {
    @State private var clothesURLString: String = ""
    @State private var clothes: Clothes?
    @State private var segmentedImage: UIImage?
    
    @State private var showSheet: Bool = false
    
    @FocusState private var isFocused: Bool
    
    @State private var horizontalScrolledID: Int? = 0
    @State private var scrolledID: Int? = 0
    @State private var closetScrollOffset: CGPoint = .zero
//    @State private var showCategory: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(.negguLogo)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 0) {
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
                                segmentation()
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
                        .padding(.bottom, 20)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("오늘 입을 룩북이")
                                            
                                            Text("1벌 ")
                                                .foregroundStyle(.orange40)
                                            +
                                            Text("있어요")
                                            
                                            Image(systemName: "arrow.right")
                                                .resizable()
                                                .fontWeight(.light)
                                                .frame(width: 54, height: 30)
                                        }
                                        
                                        Spacer()
                                    }
                                    .negguFont(.title4)
                                    .foregroundStyle(.labelAlt)
                                }
                                .padding(.horizontal, 40)
                                .containerRelativeFrame(.horizontal)
                                .frame(height: 172)
                                .padding(.horizontal, -20)
                                .background {
                                    RoundedRectangle(cornerRadius: 36)
                                        .fill(.white)
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                
                                                Image(.dummyLookbook)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 150)
                                            }
                                        }
                                }
                                .clipped()
                                .id(0)
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("빠르게 옷장에\n담아보세요!")
                                            .negguFont(.title4)
                                            .foregroundStyle(.white)
                                        
                                        Text("링크를 붙여넣어 내 옷장에 저장할 수 있어요")
                                            .negguFont(.body2b)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 40)
                                .containerRelativeFrame(.horizontal)
                                .frame(height: 172)
                                .padding(.horizontal, -20)
                                .background {
                                    RoundedRectangle(cornerRadius: 36)
                                        .fill(.black)
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                
                                                Image(.bannerBG1)
//                                                    .resizable()
//                                                    .scaledToFill()
                                                    .frame(width: 150)
                                            }
                                        }
                                }
                                .clipped()
                                .id(1)
                            }
                            .padding(.horizontal, 20)
                            .scrollTargetLayout()
                        }
                        .scrollTargetBehavior(.paging)
                        .scrollPosition(id: $horizontalScrolledID)
                        .animation(.smooth, value: horizontalScrolledID)
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, -20)
                        .id(0)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<2, id: \.self) { index in
                                Capsule()
                                    .fill(horizontalScrolledID == index ? .black : .systemInactive)
                                    .frame(width: horizontalScrolledID == index ? 24 : 8, height: 8)
                                    .onTapGesture {
                                        horizontalScrolledID = index
                                    }
                            }
                        }
                        .animation(.smooth, value: horizontalScrolledID)
                        .padding(.top, 36)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("내 옷장")
                                    .negguFont(.title2)
                                    .foregroundStyle(.labelNormal)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.top, 32)
                            
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
                                
                                Spacer()
                            }
                            .frame(height: 50)
//                            .frame(height: showCategory ? 50 : 0)
//                            .opacity(showCategory ? 1 : 0)
                            //                        .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            
                            CustomScrollView(scrollOffset: $closetScrollOffset) { _ in
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                    ForEach(0...20, id: \.self) { index in
                                        NavigationLink {
                                            LookBookView()
                                        } label: {
                                            Image("dummy_clothes\(index % 3)")
                                                .frame(height: 122)
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                            .disabled(scrolledID == 0)
                            .onChange(of: closetScrollOffset) { oldValue, newValue in
                                print(closetScrollOffset.y)
//                                withAnimation(.smooth) {
//                                    showCategory = closetScrollOffset.y < 10 || (oldValue.y > newValue.y)
//                                }
                            }
                        }
                        .containerRelativeFrame(.vertical)
                        .id(1)
                    }
                    .padding(20)
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrolledID)
                .scrollIndicators(.hidden)
                .overlay(alignment: .bottom) {
                    Text("네가 좀 꾸며줘! ✨")
                        .negguFont(.body2b)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.negguSecondary)
                        }
                        .opacity(scrolledID == 0 ? 0 : 1)
                        .offset(y: scrolledID == 0 ? 0 : -86)
                        .animation(.smooth, value: scrolledID)
                }
            }
            .background {
                Color(.bgNormal)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isFocused = false
                    }
            }
            .sheet(item: $clothes) { clothes in
                ClosetAddView(clothes: clothes, segmentedImage: $segmentedImage)
            }
        }
    }
    
    private func segmentation() {
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
            request.setValue("iPhone Pro 12", forHTTPHeaderField: "User-Agent")
        } else {
            request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
        }
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                print("Failed to get HTML content")
                return
            }
            
            do {
                let document = try SwiftSoup.parse(htmlString)
//                print(document)
                
                let scriptElements = try document.select("script[type=application/\(urlString.contains("a-bly") || urlString.contains("queenit.kr") || urlString.contains("29cm.") ? "" : "ld+")json]")
                
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
                    
                    guard let product else { return }
                    
                    let convertedProduct = product.toProduct(urlString: urlString)
                    
                    if let imageURL = URL(string: convertedProduct.image),
                       let imageData = try? Data(contentsOf: imageURL),
                       let uiImage = UIImage(data: imageData) {

                        Task {
                            let segmentedImage = await ImageAnalyzeManager.shared.segmentation(uiImage)

                            await MainActor.run {
                                self.segmentedImage = segmentedImage
                                self.clothes = .init(
                                    urlString: convertedProduct.urlString,
                                    name: convertedProduct.name,
                                    image: convertedProduct.image,
                                    brand: convertedProduct.brand,
                                    price: convertedProduct.price
                                )
                                showSheet = true
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}

#Preview {
    ClosetView()
}
