//
//  CachedAsyncImage.swift
//  neggu
//
//  Created by 유지호 on 4/13/25.
//

import SwiftUI

public struct CachedAsyncImage: View {
    @State private var phase: AsyncImagePhase = .empty
    
    private let urlString: String
    
    public init(_ urlString: String) {
        self.urlString = urlString
    }
    
    public var body: some View {
        switch phase {
        case .success(let image):
            image
                .resizable()
                .scaledToFit()
        default:
            SkeletonView()
                .task {
                    await loadImage()
                }
        }
    }
    
    @MainActor
    private func loadImage() async {
        do {
            guard let url = URL(string: urlString) else {
                throw NSError(domain: "잘못된 URL", code: 1)
            }
            
            let request = URLRequest(url: url)
            
            if let cache = URLSession.shared.configuration.urlCache,
               let cachedData = cache.cachedResponse(for: request)?.data,
               let uiImage = UIImage(data: cachedData) {
                    withAnimation(.easeIn) {
                        phase = .success(Image(uiImage: uiImage))
                    }
            } else {
                let (data, response) = try await URLSession.shared.data(for: request)
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
