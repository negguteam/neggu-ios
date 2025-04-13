//
//  String+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/21/25.
//

import UIKit

extension String {
    
    func isValidNickname() -> Bool {
        let nicknameRegex = "^[가-힣a-z0-9]{1,7}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        return predicate.evaluate(with: self)
    }
    
    func toISOFormatDate() -> Date? {
        return Date.isoFormatter.date(from: self)
    }
    
    
    func toImage() async -> UIImage? {
        guard let url = URL(string: self) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        
        if let cache = URLSession.shared.configuration.urlCache,
           let cachedData = cache.cachedResponse(for: request)?.data,
           let uiImage = UIImage(data: cachedData) {
            return uiImage
        } else {
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let cachedData = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedData, for: request)
                return UIImage(data: data)
            } catch {
                return nil
            }
        }
    }
    
}
