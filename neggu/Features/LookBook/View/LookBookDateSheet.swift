//
//  LookBookDateSheet.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct LookBookDateSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMonth: Date = .currentMonth
    @State private var sheetHeight: CGFloat = .zero
    
    @Binding var selectedDate: Date?
    
    var selectedMonthDates: [Day] {
        extractDates(selectedMonth)
    }
    
    var body: some View {
        NegguSheet {
            VStack(spacing: 24) {
                if let date = selectedDate {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondaryAlt)
                        .frame(height: 60)
                        .overlay {
                            HStack(spacing: 0) {
                                Image(.calendar)
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
                }
                
                LazyVGrid(
                    columns: [GridItem](repeating: .init(spacing: 4), count: 7),
                    spacing: 2
                ) {
                    ForEach(Date.weekdaySymbols, id: \.self) { symbol in
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
                                .fill(selectedDate == day.date
                                      ? .negguSecondary
                                      : day.date == Date.now.yearMonthDay()
                                      ? .negguSecondaryAlt
                                      : .clear
                                )
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
                .padding(.top, 8)
                
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
                .padding(.bottom, 24)
            }
            .padding(.horizontal, 20)
        } header: {
            HStack {
                Image(.chevronLeft)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        updateMonth(false)
                    }
                
                Text(selectedMonth.yearMonthFormatted())
                    .negguFont(.body1b)
                    .frame(maxWidth: .infinity)
                
                Image(.chevronRight)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        updateMonth()
                    }
            }
            .foregroundStyle(.labelNormal)
        }
        .heightChangePreference { sheetHeight = $0 }
        .presentationDetents([.height(sheetHeight)])
    }
    
    func updateMonth(_ increment: Bool = true) {
        let calendar = Calendar.current
        guard let month = calendar.date(byAdding: .month, value: increment ? 1 : -1, to: selectedMonth),
              calendar.component(.month, from: month) >= calendar.component(.month, from: .now)
        else { return }
        
        selectedMonth = month
    }
    
    func dateColor(_ day: Day) -> some ShapeStyle {
        if selectedDate == day.date {
            return .white
        } else if day.date < .now.yearMonthDay() {
            return .labelInactive
        } else if day.shortSymbol == "Sun" {
            return .warning
        } else if day.shortSymbol == "Sat" {
            return .labelAssistive
        } else {
            return .labelNormal
        }
    }
    
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
    
    struct Day: Identifiable {
        var id: UUID = .init()
        var shortSymbol: String
        var date: Date
        var ignored: Bool = false
    }
}

#Preview {
    LookBookDateSheet(selectedDate: .constant(.now))
}
