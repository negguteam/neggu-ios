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
    @State private var showCategory: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            VStack(spacing: 32) {
                                HStack {
                                    Spacer()
                                    
                                    Text("이용안내")
                                        .negguFont(.body2b)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background {
                                            Capsule()
                                                .fill(.orange40)
                                        }
                                    
                                    Image(systemName: "questionmark.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.gray40)
                                }
                                
                                Spacer()
                                //                            Rectangle()
                                //                                .frame(height: 120)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Circle()
                                            .fill(.gray40)
                                            .frame(width: 64)
                                            .overlay {
                                                Image(systemName: "person.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 24)
                                                    .foregroundStyle(.white)
                                            }
                                    }
                                    
                                    Text("빠르게 옷장에\n담아보세요!")
                                        .negguFont(.title2)
                                        .foregroundStyle(.white)
                                        .layoutPriority(1)
                                    
                                    Text("링크를 붙여넣어 내 옷장에 저장할 수 있어요")
                                        .negguFont(.body2)
                                        .foregroundStyle(.white)
                                        .padding(.bottom, 32)
                                    
                                    HStack {
                                        Image(systemName: "link")
                                        
                                        TextField("무신사, 지그재그...", text: $clothesURLString)
                                            .focused($isFocused)
                                        
                                        Button {
                                            //                                            if clothesURLString.isEmpty { return }
                                            //                                            segmentation()
                                            showSheet.toggle()
                                        } label: {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.black)
                                                .frame(width: 32, height: 32)
                                                .overlay {
                                                    Image(systemName: "arrow.right")
                                                        .foregroundStyle(.white)
                                                }
                                        }
                                    }
                                    .padding(8)
                                    .frame(height: 48)
                                    .background {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(.gray10)
                                    }
                                }
                            }
                            .padding(24)
                            .background {
                                RoundedRectangle(cornerRadius: 36)
                            }
                            .frame(width: 354, height: 620)
                            .id(0)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("8/1일 (금)")
                                        .negguFont(.body2b)
                                        .foregroundStyle(.orange40)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background {
                                            Capsule()
                                                .fill(.orange10)
                                        }
                                    
                                    Spacer()
                                }
                                
                                Text("오늘 입을 옷이\n있어요!")
                                    .negguFont(.title2)
                                    .foregroundStyle(.white)
                                //                            Rectangle()
                                //                                .fill(.clear)
                                
                                Spacer()
                            }
                            .padding(24)
                            .frame(width: 354, height: 620)
                            .background {
                                RoundedRectangle(cornerRadius: 36)
                                    .fill(.orange40)
                            }
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
                                .fill(horizontalScrolledID == index ? .black : .gray30)
                                .frame(width: horizontalScrolledID == index ? 24 : 8, height: 8)
                                .onTapGesture {
                                    horizontalScrolledID = index
                                }
                        }
                    }
                    .animation(.smooth, value: horizontalScrolledID)
                    .padding(.top)
                    .padding(.bottom, 64)
                    
                    //                if let clothes {
                    //                    VStack {
                    //                        if let segmentedImage {
                    //                            Image(uiImage: segmentedImage)
                    //                                .resizable()
                    //                                .aspectRatio(contentMode: .fit)
                    //                                .frame(width: 120, height: 150)
                    //                        } else {
                    //                            AsyncImage(url: URL(string: clothes.image)) { image in
                    //                                image
                    //                                    .resizable()
                    //                                    .aspectRatio(contentMode: .fit)
                    //                            } placeholder: {
                    //                                ProgressView()
                    //                            }
                    //                            .frame(width: 120, height: 150)
                    //                        }
                    //
                    //                        VStack(alignment: .leading) {
                    //                            Text(clothes.name)
                    //
                    //                            Text(clothes.brand)
                    //
                    //                            Text(clothes.price.formatted() + "원")
                    //
                    //                            Text(clothes.urlString)
                    //                                .font(.caption)
                    //                        }
                    //                    }
                    //                }
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("내 옷장")
                                .negguFont(.title2)
                            
                            Spacer()
                            
                            Button {
                                showSheet = true
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.orange10)
                                    .frame(width: 48, height: 48)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundStyle(.orange40)
                                    }
                                    .opacity(scrolledID == 0 ? 0 : 1)
                                    .animation(.smooth, value: scrolledID)
                            }
                            .disabled(scrolledID == 0)
                        }
                        .padding(.horizontal, 28)
                        .padding(.top)
                        
                        HStack {
                            ForEach(0..<3, id: \.self) { _ in
                                HStack {
                                    Text("카테고리")
                                    
                                    Image(systemName: "chevron.down")
                                }
                                .negguFont(.body3b)
                                .foregroundStyle(.black.opacity(0.4))
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.gray10)
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(height: showCategory ? 50 : 0)
                        .opacity(showCategory ? 1 : 0)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 8)
                        
                        CustomScrollView(scrollOffset: $closetScrollOffset) { _ in
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach(0...40, id: \.self) { index in
                                    NavigationLink {
                                        LookBookView()
                                    } label: {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.gray10)
                                            .frame(height: 122)
                                        //                                            .onTapGesture {
                                        //                                                print("\(index)")
                                        //                                            }
                                    }
                                }
                            }
                            .padding(.vertical)
                            //                        Rectangle()
                            //                            .fill(.orange)
                            //                            .frame(height: 1000)
                        }
                        .onChange(of: closetScrollOffset) { oldValue, newValue in
                            print(closetScrollOffset.y)
                            withAnimation(.smooth) {
                                showCategory = closetScrollOffset.y < 10 || (oldValue.y > newValue.y)
                            }
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
                    .padding(8)
                    .background {
                        Capsule()
                            .fill(.orange40)
                    }
                    .opacity(scrolledID == 0 ? 0 : 1)
                    .offset(y: scrolledID == 0 ? 0 : -32)
                    .animation(.smooth, value: scrolledID)
            }
            .background {
                Color(.systemBackground)
                    .onTapGesture {
                        isFocused = false
                    }
            }
            .sheet(isPresented: $showSheet) {
                ClosetAddView()
            }
        }
    }
    
//    private func segmentation() {
//        var urlString = clothesURLString
//        
//        if urlString.contains("a-bly") {
//            urlString = urlString.replacingOccurrences(of: "a-bly.com/app", with: "m.a-bly.com")
//        }
//        
//        guard let url = URL(string: urlString) else {
//            print("invalid url")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        
//        if urlString.contains("kream") || urlString.contains("goodw") {
//            request.setValue("iPhone Pro 12", forHTTPHeaderField: "User-Agent")
//        } else {
//            request.setValue("Chrome/92.0.4515.107", forHTTPHeaderField: "User-Agent")
//        }
//            
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
//                print("Failed to get HTML content")
//                return
//            }
//            
//            do {
//                let document = try SwiftSoup.parse(htmlString)
////                print(document)
//                
//                let scriptElements = try document.select("script[type=application/\(urlString.contains("a-bly") || urlString.contains("queenit.kr") || urlString.contains("29cm.") ? "" : "ld+")json]")
//                
//                for element in scriptElements {
//                    let jsonString = try element.html()//.replacingOccurrences(of: "\"\"", with: "\"")
//                    
//                    guard let data = jsonString.data(using: .utf8) else { return }
//                    
//                    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
//                        .documentType: NSAttributedString.DocumentType.html,
//                        .characterEncoding: String.Encoding.utf8.rawValue
//                    ]
//                    
//                    let attributedString = try NSAttributedString(data: data, options: options, documentAttributes: nil)
//                    print(attributedString)
//                    print()
//                    
//                    if let parsedData = attributedString.string.data(using: .utf8) {
//                        var product: Clothesable?
//                        
//                        if urlString.contains("kream") {
//                            product = try? JSONDecoder().decode(KreamProduct.self, from: parsedData)
//                        } else if urlString.contains("musinsa") {
//                            product = try? JSONDecoder().decode(MusinsaProduct.self, from: parsedData)
//                        } else if urlString.contains("zigzag") {
//                            product = try? JSONDecoder().decode(ZigzagProduct.self, from: parsedData)
//                        } else if urlString.contains("a-bly") {
//                            product = try? JSONDecoder().decode(AblyProduct.self, from: parsedData)
//                        } else if urlString.contains("queenit.") {
//                            product = try? JSONDecoder().decode(QueenitProduct.self, from: parsedData)
//                        } else if urlString.contains("29cm.") {
//                            product = try? JSONDecoder().decode(TwentyNineCMProduct.self, from: parsedData)
//                        } else {
//                            product = nil
//                        }
//                        
//                        if let product {
//                            let convertedProduct = product.toProduct(urlString: urlString)
//                            
//                            if let imageURL = URL(string: convertedProduct.image),
//                               let imageData = try? Data(contentsOf: imageURL),
//                               let uiImage = UIImage(data: imageData) {
//
//                                Task {
//                                    let segmentedImage = await ImageAnalyzeManager.shared.segmentation(uiImage)
//                                    self.segmentedImage = segmentedImage
//                                    
//                                    self.clothes = .init(
//                                        urlString: convertedProduct.urlString,
//                                        name: convertedProduct.name,
//                                        image: convertedProduct.image,
//                                        brand: convertedProduct.brand,
//                                        price: convertedProduct.price
//                                    )
//                                    
//                                    showSheet = true
//                                }
//                            }
//                            
//                        }
//                    }
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        
//        task.resume()
//    }
}

#Preview {
    ClosetView()
}
