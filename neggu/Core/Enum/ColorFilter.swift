//
//  ColorFilter.swift
//  neggu
//
//  Created by 유지호 on 1/10/25.
//


import SwiftUI

enum ColorFilter: CaseIterable, Identifiable {
    case white
    case gray
    case black
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    case brown
    
    var id: String { "\(self)" }
    
    var color: Color {
        switch self {
        case .white: .white
        case .gray: .gray30
        case .black: .black
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        case .blue: .blue
        case .purple: .purple
        case .pink: .pink
        case .brown: .brown
        }
    }
}