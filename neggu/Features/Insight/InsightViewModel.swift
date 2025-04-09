//
//  InsightViewModel.swift
//  neggu
//
//  Created by 유지호 on 4/10/25.
//

import Foundation
import Combine

final class InsightViewModel: ObservableObject {
    
    @Published private var bag = Set<AnyCancellable>()
    
    private let insightService: InsightService = DefaultInsightService()
    
    
    init() { }
    
    
    func getInsight(completion: @escaping (InsightEntity) -> Void) {
        insightService.getInsight()
            .sink { event in
                print("InsightViewModel:", event)
            } receiveValue: { insight in
                completion(insight)
            }.store(in: &bag)
    }
    
}
