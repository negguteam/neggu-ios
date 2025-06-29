//
//  ColorFilter.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//

import Core
import NegguDS

import SwiftUI

public enum ColorFilter: CaseIterable, Identifiable {
    case WHITE
    case GRAY
    case BLACK
    case RED
    case ORANGE
    case YELLOW
    case GREEN
    case BLUE
    case PURPLE
    case PINK
    case BROWN
    
    public var id: String { "\(self)" }
    
    public var title: String {
        switch self {
        case .WHITE: "흰색"
        case .GRAY: "회색"
        case .BLACK: "검정색"
        case .RED: "빨간색"
        case .ORANGE: "주황색"
        case .YELLOW: "노랑색"
        case .GREEN: "초록색"
        case .BLUE: "파랑색"
        case .PURPLE: "보라색"
        case .PINK: "분홍색"
        case .BROWN: "갈색"
        }
    }
    
    public var color: Color {
        switch self {
        case .WHITE: .white
        case .GRAY: NegguDSAsset.Colors.gray30.swiftUIColor
        case .BLACK: .black
        case .RED: .red
        case .ORANGE: NegguDSAsset.Colors.filterOrange.swiftUIColor
        case .YELLOW: NegguDSAsset.Colors.filterYellow.swiftUIColor
        case .GREEN: NegguDSAsset.Colors.filterGreen.swiftUIColor
        case .BLUE: NegguDSAsset.Colors.filterBlue.swiftUIColor
        case .PURPLE: NegguDSAsset.Colors.filterPurple.swiftUIColor
        case .PINK: NegguDSAsset.Colors.filterPink.swiftUIColor
        case .BROWN: NegguDSAsset.Colors.filterBrown.swiftUIColor
        }
    }
    
    public var hexCode: String {
        switch self {
        case .WHITE: "#FFFFFF"
        case .GRAY: "#838383"
        case .BLACK: "#000000"
        case .RED: "#B23528"
        case .ORANGE: "#C54D2E"
        case .YELLOW: "#F3E554"
        case .GREEN: "#4EA02A"
        case .BLUE: "#1C17E9"
        case .PURPLE: "#351554"
        case .PINK: "#C43B86"
        case .BROWN: "#452B15"
        }
    }
    
    public var rgb: (r: Int, g: Int, b: Int) {
        switch self {
        case .WHITE: (255, 255, 255)
        case .GRAY: (131, 131, 131)
        case .BLACK: (0, 0, 0)
        case .RED: (178, 53, 40)
        case .ORANGE: (197, 77, 46)
        case .YELLOW: (243, 229, 84)
        case .GREEN: (78, 160, 42)
        case .BLUE: (28, 23, 233)
        case .PURPLE: (53, 21, 84)
        case .PINK: (196, 59, 134)
        case .BROWN: (69, 43, 21)
        }
    }
    
    public init(color: UIColor) {
        self = ColorFilter.closestColorName(to: color) ?? .WHITE
    }
    
    public static func closestColorName(to color: UIColor) -> Self? {
        guard let targetRGB = color.toRGB() else { return nil }

        var closestColor: ColorFilter?
        var minDistance = Double.infinity

        for color in Self.allCases {
            let distance = sqrt(
                pow(Double(targetRGB.r - color.rgb.r), 2) +
                pow(Double(targetRGB.g - color.rgb.g), 2) +
                pow(Double(targetRGB.b - color.rgb.b), 2)
            )

            if distance < minDistance {
                minDistance = distance
                closestColor = color
            }
        }

        return closestColor
    }
}


public extension Date {
    
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
            let dayString = self.yearMonthDay().toRelativeFormatString()
            return (dayString, .labelNormal)
        } else if week.contains(self.yearMonthDay()) {
            return (self.daySymbol(), .labelNormal)
        } else {
            return (self.monthDayFormatted(), NegguDSAsset.Colors.gray50.swiftUIColor)
        }
    }
    
}
