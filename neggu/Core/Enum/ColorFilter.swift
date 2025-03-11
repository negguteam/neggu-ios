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
