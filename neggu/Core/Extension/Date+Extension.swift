//
//  Date+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/13/25.
//

import SwiftUI

extension Date {
    
    static var weekdaySymbols: [String] {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "en-US")
        return calendar.weekdaySymbols.map { String($0.prefix(3)) }
    }
    
    static var currentMonth: Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(
            from: Calendar.current.dateComponents(
                [.month, .year],
                from: .now
            )
        ) else {
            return .now
        }
        
        return currentMonth
    }
    
    static var yearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func yearMonthDayFormatted() -> String {
        Self.yearMonthDayFormatter.string(from: self)
    }
    
    func yearMonthDay() -> Date {
        Self.yearMonthDayFormatter.date(from: self.yearMonthDayFormatted())!// ?? .now
    }
    
    static var yearMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }
    
    func yearMonthFormatted() -> String {
        Self.yearMonthFormatter.string(from: self)
    }
    
    static var monthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }
    
    func monthDayFormatted() -> String {
        Self.monthDayFormatter.string(from: self)
    }
    
    static var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
    
    func dayFormatted() -> String {
        Self.dayFormatter.string(from: self)
    }
    
    func daySymbol() -> String {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "ko-KR")
        formatter.dateFormat = "EEE"
        
        return formatter.string(from: self)
    }
    
    func generateLookBookDate() -> (String, Color) {
        let twoDaysAfter = Calendar.current.date(byAdding: .day, value: 2, to: Date.now.yearMonthDay())!
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let today = calendar.startOfDay(for: Date.now)
        var week: [Date] = []
        
        if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: today) {
            for i in 0...6 {
                if let day = calendar.date(byAdding: .day, value: i, to: weekInterval.start) {
                    week += [day]
                }
            }
        }
        
        if self.yearMonthDay() == Date.now.yearMonthDay() {
            return ("오늘", .negguSecondary)
        } else if self.yearMonthDay() <= twoDaysAfter {
            let formatter = RelativeDateTimeFormatter()
            formatter.dateTimeStyle = .named
            let dayString = formatter.localizedString(for: self.yearMonthDay(), relativeTo: .now.yearMonthDay())
            return (dayString, .labelNormal)
        } else if week.contains(self.yearMonthDay()) {
            return (self.daySymbol(), .labelNormal)
        } else {
            return (self.monthDayFormatted(), .gray50)
        }
    }
    
}


// MARK: ISOFormat
extension Date {
    
    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()
    
    static let lookBookDetailDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter
    }()
    
    func toISOFormatString() -> String {
        return Self.isoFormatter.string(from: self)
    }
    
    func toLookBookDetailDateString() -> String {
        return Self.lookBookDetailDateFormatter.string(from: self)
    }
    
}
