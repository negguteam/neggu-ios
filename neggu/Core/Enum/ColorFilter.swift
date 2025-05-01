//
//  ColorFilter.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//


import SwiftUI

enum ColorFilter: CaseIterable, Identifiable {
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
    
    var id: String { "\(self)" }
    
    var title: String {
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
    
    var color: Color {
        switch self {
        case .WHITE: .white
        case .GRAY: .gray30
        case .BLACK: .black
        case .RED: .red
        case .ORANGE: .filterOrange
        case .YELLOW: .filterYellow
        case .GREEN: .filterGreen
        case .BLUE: .filterBlue
        case .PURPLE: .filterPurple
        case .PINK: .filterPink
        case .BROWN: .filterBrown
        }
    }
    
    var hexCode: String {
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
    
    var rgb: (r: Int, g: Int, b: Int) {
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
    
    init(color: UIColor) {
        self = ColorFilter.closestColorName(to: color) ?? .WHITE
    }
    
    static func closestColorName(to color: UIColor) -> Self? {
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
