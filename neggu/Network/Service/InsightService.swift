//
//  InsightService.swift
//  neggu
//
//  Created by 유지호 on 4/8/25.
//

import Foundation
import Combine

typealias DefaultInsightService = BaseService<InsightAPI>

protocol InsightService {
    func getInsight() -> AnyPublisher<InsightEntity, Error>
}

extension DefaultInsightService: InsightService {
    
    func getInsight() -> AnyPublisher<InsightEntity, Error> {
        requestObjectWithNetworkError(.getInsight)
    }
    
}
