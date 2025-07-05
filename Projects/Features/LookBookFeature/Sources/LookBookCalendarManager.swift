//
//  LookBookCalendarManager.swift
//  LookBookFeature
//
//  Created by 유지호 on 7/5/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Networks

import Foundation
import Combine

public struct LookBookCalendarItem: Codable, Identifiable {
    public let lookBook: LookBookEntity
    public var targetDate: Date
    
    public var id: String { self.lookBook.id }
}

public final class LookBookCalendarManager {
    
    public let lookBookList = CurrentValueSubject<[LookBookCalendarItem], Never>([])
    
    public static let shared = LookBookCalendarManager()
    
    private init() {
        checkExpiredLookBook()
    }
    
    
    public func checkLookBook(_ id: String) -> Date? {
        return lookBookList.value.first(where: { $0.lookBook.id == id })?.targetDate
    }
    
    public func addLookBook(_ lookBook: LookBookEntity, targetDate: Date) {
        var current = lookBookList.value
        
        if let index = current.firstIndex(where: { $0.lookBook.id == lookBook.id }) {
            current[index].targetDate = targetDate
        } else {
            current.append(.init(lookBook: lookBook, targetDate: targetDate))
        }
        
        lookBookList.send(current.sorted(by: { $0.targetDate < $1.targetDate }))
        saveCalendar()
    }
    
    public func removeLookBook(id: String) {
        var current = lookBookList.value
        current.removeAll { $0.lookBook.id == id }
        lookBookList.send(current)
        saveCalendar()
    }
    
    private func saveCalendar() {
        do {
            let data = try JSONEncoder().encode(lookBookList.value)
            UserDefaults.standard.set(data, forKey: "LookBookCalendar")
        } catch {
            debugPrint("Failed to encode Calendar:", error.localizedDescription)
        }
    }
    
    private func loadCalendar() {
        do {
            guard let data = UserDefaults.standard.data(forKey: "LookBookCalendar") else {
                debugPrint("Failed to load Calendar")
                return
            }
            
            let calendar = try JSONDecoder().decode([LookBookCalendarItem].self, from: data)
            lookBookList.send(calendar)
        } catch {
            debugPrint("Failed to decode Calendar:", error.localizedDescription)
        }
    }
    
    private func checkExpiredLookBook() {
        loadCalendar()
        
        guard let yesterday = Calendar.current.date(
            byAdding: .day,
            value: -1,
            to: .now.yearMonthDay()
        ) else { return }
        
        var current = lookBookList.value
        current.removeAll { $0.targetDate < yesterday }
        lookBookList.send(current)
    }
    
}
