//
//  NegguColor.swift
//  neggu
//
//  Created by 유지호 on 11/4/24.
//

import SwiftUI

public extension Color {
    
    // MARK: Brand
    public static let negguPrimary: Color = .black
    public static let negguPrimaryAlt: Color = .blue10
    public static let negguSecondary: Color = .orange40
    public static let negguSecondaryAlt: Color = .orange10
    
    
    // MARK: System
    public static let systemWarning: Color = .warning
    public static let systemWarningAlt: Color = .warningAlt
    public static let systemSafe: Color = .safe
    public static let systemSafeAlt: Color = .safeAlt
    public static let systemInactive: Color = .inactive
    
    
    // MARK: Gray
    // Label
    public static let labelNormal: Color = .gray90
    public static let labelAlt: Color = .gray60
    public static let labelAssistive: Color = .black.opacity(0.4)
    public static let labelRNormal: Color = .white
    public static let labelRAlt: Color = .gray5
    public static let labelRAssistive: Color = .white.opacity(0.7)
    public static let labelInactive: Color = .gray30
    
    // Background
    public static let bgNormal: Color = .gray5
    public static let bgAlt: Color = .gray10
    public static let bgInactive: Color = .gray10
    public static let bgDimmed: Color = .black.opacity(0.5)
    public static let bgRNormal: Color = .black
    
    // Line
    public static let lineNormal: Color = .black.opacity(0.2)
    public static let lineAlt: Color = .black.opacity(0.1)
    public static let lineRNormal: Color = .black.opacity(0.2)
    public static let lineRAlt: Color = .black.opacity(0.1)
    
}


extension ShapeStyle where Self == Color {
    
    // MARK: Brand
    static var negguPrimary: Color { .negguPrimary }
    static var negguPrimaryAlt: Color { .negguPrimaryAlt }
    static var negguSecondary: Color { .negguSecondary }
    static var negguSecondaryAlt: Color { .negguSecondaryAlt }
    
    
    // MARK: System
    static var systemWarning: Color { .systemWarning }
    static var systemWarningAlt: Color { .systemWarningAlt }
    static var systemSafe: Color { .systemSafe }
    static var systemSafeAlt: Color { .systemSafeAlt }
    static var systemInactive: Color { .systemInactive }
    
    
    // MARK: Gray
    // Label
    static var labelNormal: Color { .labelNormal }
    static var labelAlt: Color { .labelAlt }
    static var labelAssistive: Color { .labelAssistive }
    static var labelRNormal: Color { .labelRNormal }
    static var labelRAlt: Color { .labelRAlt }
    static var labelRAssistive: Color { .labelRAssistive }
    static var labelInactive: Color { .labelInactive }
    
    // Background
    static var bgNormal: Color { .bgNormal }
    static var bgAlt: Color { .bgAlt }
    static var bgInactive: Color { .bgInactive }
    static var bgDimmed: Color { .bgDimmed }
    static var bgRNormal: Color { .bgRNormal }
    
    // Line
    static var lineNormal: Color { .lineNormal }
    static var lineAlt: Color { .lineAlt }
    static var lineRNormal: Color { .lineRNormal }
    static var lineRAlt: Color { .lineRAlt }
    
}
