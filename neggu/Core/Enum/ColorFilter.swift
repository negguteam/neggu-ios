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
}
