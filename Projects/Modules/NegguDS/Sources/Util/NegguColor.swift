//
//  NegguColor.swift
//  neggu
//
//  Created by 유지호 on 11/4/24.
//

import SwiftUI

public extension Color {
    
    // MARK: Brand
    static let negguPrimary: Color = .black
    static let negguPrimaryAlt: Color = NegguDSAsset.Colors.blue10.swiftUIColor
    static let negguSecondary: Color = NegguDSAsset.Colors.orange40.swiftUIColor
    static let negguSecondaryAlt: Color = NegguDSAsset.Colors.orange10.swiftUIColor
    
    
    // MARK: System
    static let systemWarning: Color = NegguDSAsset.Colors.warning.swiftUIColor
    static let systemWarningAlt: Color = NegguDSAsset.Colors.warningAlt.swiftUIColor
    static let systemSafe: Color = NegguDSAsset.Colors.safe.swiftUIColor
    static let systemSafeAlt: Color = NegguDSAsset.Colors.safeAlt.swiftUIColor
    static let systemInactive: Color = NegguDSAsset.Colors.inactive.swiftUIColor
    
    
    // MARK: Gray
    // Label
    static let labelNormal: Color = NegguDSAsset.Colors.gray90.swiftUIColor
    static let labelAlt: Color = NegguDSAsset.Colors.gray60.swiftUIColor
    static let labelAssistive: Color = .black.opacity(0.4)
    static let labelRNormal: Color = .white
    static let labelRAlt: Color = NegguDSAsset.Colors.gray5.swiftUIColor
    static let labelRAssistive: Color = .white.opacity(0.7)
    static let labelInactive: Color = NegguDSAsset.Colors.gray30.swiftUIColor
    
    // Background
    static let bgNormal: Color = NegguDSAsset.Colors.gray5.swiftUIColor
    static let bgAlt: Color = NegguDSAsset.Colors.gray10.swiftUIColor
    static let bgInactive: Color = NegguDSAsset.Colors.gray10.swiftUIColor
    static let bgDimmed: Color = .black.opacity(0.5)
    static let bgRNormal: Color = .black
    
    // Line
    static let lineNormal: Color = .black.opacity(0.2)
    static let lineAlt: Color = .black.opacity(0.1)
    static let lineRNormal: Color = .black.opacity(0.2)
    static let lineRAlt: Color = .black.opacity(0.1)
    
}


public extension ShapeStyle where Self == Color {
    
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
