//
//  LookBookDateEditView.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct LookBookDateEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMonth: Date = .currentMonth
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
                .padding(.bottom, 32)
            
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        updateMonth(false)
                    }
                
                Text(selectedMonth.yearMonthFormatted())
                    .negguFont(.body1b)
                    .frame(maxWidth: .infinity)
                
                Image(systemName: "chevron.right")
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        updateMonth()
                    }
            }
            .foregroundStyle(.labelNormal)
            .padding(.horizontal, 28)
            .padding(.bottom)
            
            if let date = selectedDate {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.negguSecondaryAlt)
                    .frame(height: 60)
                    .overlay {
                        HStack(spacing: 0) {
                            Image(systemName: "calendar")
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 4)
                            
                            Text(date.monthDayFormatted())
                            
                            Text("에 입을 예정이에요")
                                .foregroundStyle(.labelNormal)
                            
                            Spacer()
                            
                            Button {
                                selectedDate = nil
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.warning)
                                    .frame(width: 63, height: 44)
                                    .overlay {
                                        Text("삭제")
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                        .negguFont(.body2b)
                        .foregroundStyle(.negguSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    .padding(.bottom)
            }
            
            LazyVGrid(
                columns: [GridItem](repeating: .init(spacing: 4), count: 7),
                spacing: 2
            ) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .negguFont(.caption)
                        .foregroundStyle(
                            symbol == "Sun" ? .warning
                            : symbol == "Sat" ? .labelAssistive
                            : .labelAlt
                        )
                }
                .padding(.bottom, 2)
                
                ForEach(selectedMonthDates) { day in
                    if day.date >= selectedMonth {
                        Circle()
                            .fill(selectedDate == day.date ? .negguSecondary : day.date == Date.now.yearMonthDay() ? .negguSecondaryAlt : .clear)
                            .overlay {
                                Text(day.date.dayFormatted())
                                    .negguFont(.body2b)
                                    .foregroundStyle(dateColor(day))
                            }
                            .onTapGesture {
                                if day.ignored || selectedDate == day.date { return }
                                dismiss()
                                selectedDate = day.date
                            }
                    } else {
                        Circle()
                            .fill(.clear)
                    }
                }
            }
            
            HStack {
                let today = Date.now.yearMonthDay()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date.now.yearMonthDay())!
                let twoDaysAfter = Calendar.current.date(byAdding: .day, value: 2, to: Date.now.yearMonthDay())!
                
                Button {
                    selectedDate = today
                } label: {
                    DateSelectButton(selectedDate: $selectedDate, title: "오늘", date: today)
                }
                
                Button {
                    selectedDate = tomorrow
                } label: {
                    DateSelectButton(selectedDate: $selectedDate, title: "내일", date: tomorrow)
                }
                
                Button {
                    selectedDate = twoDaysAfter
                } label: {
                    DateSelectButton(selectedDate: $selectedDate, title: "모레", date: twoDaysAfter)
                }
            }
            .padding(.horizontal, 28)
        }
        .padding(20)
        .background(.bgNormal)
    }
    
    var weekdaySymbols: [String] {
        var calendar = Calendar.current
        calendar.locale = .init(identifier: "en-US")
        return calendar.weekdaySymbols.map { String($0.prefix(3)) }
    }
    
    var selectedMonthDates: [Day] {
        return extractDates(selectedMonth)
    }
    
    func updateMonth(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(
            byAdding: .month,
            value: increment ? 1 : -1,
            to: selectedMonth
        ) else { return }
        
        selectedMonth = month
    }
    
    func dateColor(_ day: Day) -> some ShapeStyle {
        if selectedDate == day.date {
            return .white
        } else if day.shortSymbol == "Sun" {
            return .warning
        } else if day.shortSymbol == "Sat" {
            return .labelAssistive
        } else {
            return .labelNormal
        }
    }
}


extension View {
    
    func extractDates(_ month: Date) -> [Day] {
        var days: [Day] = []
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "un-En")
        formatter.dateFormat = "EEE"
        
        guard let range = calendar.range(
            of: .day,
            in: .month,
            for: month
        )?.compactMap ({
            calendar.date(byAdding: .day, value: $0 - 1, to: month)
        }) else { return days }
        
        let firstWeekDay = calendar.component(.weekday, from: range.first!)
        
        for index in Array(0..<firstWeekDay - 1).reversed() {
            guard let date = calendar.date(
                byAdding: .day,
                value: -index - 1,
                to: range.first!
            ) else { return days }
            
            let shortSymbol = formatter.string(from: date)
            days.append(.init(shortSymbol: shortSymbol, date: date, ignored: true))
        }
        
        range.forEach {
            let shortSymbol = formatter.string(from: $0)
            let ignored = $0.yearMonthDayFormatted() < Date.now.yearMonthDayFormatted()
            days.append(.init(shortSymbol: shortSymbol, date: $0, ignored: ignored))
        }
        
        return days
    }
    
}

extension Date {
    
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
            return (self.monthDayFormatted(), .labelNormal)
        }
    }
    
}

struct Day: Identifiable {
    var id: UUID = .init()
    var shortSymbol: String
    var date: Date
    var ignored: Bool = false
}

#Preview {
    LookBookDateEditView(selectedDate: .constant(.now))
}
