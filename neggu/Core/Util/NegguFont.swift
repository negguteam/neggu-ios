//
//  NegguFont.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

enum NegguFont {
    case title1
    case title2
    case title3
    case body1
    case body2
    case body3
    case caption
    
    var fontName: String {
        switch self {
        case .body3:
            return "Pretendard-Regular"
        default:
            return "Pretendard-Medium"
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .title1:  return 48.0
        case .title2:  return 36.0
        case .title3:  return 24.0
        case .body1:   return 20.0
        case .body2:   return 16.0
        case .body3:   return 14.0
        case .caption: return 12.0
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1:  return 68.0
        case .title2:  return 60.0
        case .title3:  return 50.0
        case .body1:   return 42.0
        case .body2:   return 36.0
        case .body3:   return 42.0
        case .caption: return 30.0
        }
    }
}


struct FontModifier: ViewModifier {
    let font: NegguFont
    
    init(_ font: NegguFont) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        let lineHeight = font.lineHeight
        let fontHeight = font.fontSize
        
        content
            .font(.custom(font.fontName, size: font.fontSize))
            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, (lineHeight - fontHeight) / 2)
    }
}

extension View {
    
    func negguFont(_ font: NegguFont) -> some View {
        modifier(FontModifier(font))
    }
    
}
