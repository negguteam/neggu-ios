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
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "link")
                
                TextField("링크로 옷장에 담기", text: $clothesURLString)
                    .focused($isFocused)
                
                Button("검색") {
                    if clothesURLString.isEmpty { return }
                    segmentation()
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.gray10)
            }
            
            if let clothes {
                VStack {
                    if let segmentedImage {
                        Image(uiImage: segmentedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 150)
                    } else {
                        AsyncImage(url: URL(string: clothes.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 150)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(clothes.name)
                        
                        Text(clothes.brand)
                        
                        Text(clothes.price.formatted() + "원")
                        
                        Text(clothes.urlString)
                            .font(.caption)
                    }
                }
            }
        }
        .padding(20)
        .background {
            Color(.systemBackground)
                .onTapGesture {
                    isFocused = false
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
                    
                    if let parsedData = attributedString.string.data(using: .utf8) {
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
                        
                        if let product {
                            let convertedProduct = product.toProduct(urlString: urlString)
                            
                            if let imageURL = URL(string: convertedProduct.image),
                               let imageData = try? Data(contentsOf: imageURL),
                               let uiImage = UIImage(data: imageData) {

                                Task {
                                    let segmentedImage = await ImageAnalyzeManager.shared.segmentation(uiImage)
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
