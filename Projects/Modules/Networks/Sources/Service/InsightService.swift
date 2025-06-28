//
//  InsightService.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Foundation
import Combine

public typealias DefaultInsightService = BaseService<InsightAPI>

public protocol InsightService {
    func getInsight() -> AnyPublisher<InsightEntity, Error>
}

extension DefaultInsightService: InsightService {
    
    public func getInsight() -> AnyPublisher<InsightEntity, Error> {
        requestObjectWithNetworkError(.getInsight)
    }
    
}
