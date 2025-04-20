//
//  CachedAsyncImage.swift
//  neggu
//
//  Created by 유지호 on 4/13/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    @State private var phase: AsyncImagePhase = .empty
    
    private let session = URLSession.shared
    private let urlString: String
    
    init(_ urlString: String) {
        self.urlString = urlString
    }
    
    var body: some View {
        switch phase {
        case .success(let image):
            image
                .resizable()
                .scaledToFit()
        case .failure:
            Color.clear
                .overlay {
                    ProgressView()
                }
        default:
            Color.clear
                .task {
                    await loadImage()
                }
        }
    }
    
    private func loadImage() async {
        do {
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "잘못된 URL", code: 1)
            }
            
            let request = URLRequest(url: url)
            
            if let cache = session.configuration.urlCache,
               let cachedData = cache.cachedResponse(for: request)?.data,
               let uiImage = UIImage(data: cachedData) {
                    withAnimation(.easeIn) {
                        phase = .success(Image(uiImage: uiImage))
                    }
            } else {
                let (data, response) = try await session.data(for: request)
                let cachedData = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
                
                guard let uiImage = UIImage(data: data) else {
                    throw NSError(domain: "잘못된 Data", code: 2)
                }
                
                withAnimation(.easeIn) {
                    phase = .success(Image(uiImage: uiImage))
                }
            }
        } catch {
            phase = .failure(error)
        }
    }
}
