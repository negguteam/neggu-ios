//
//  NegguFont.swift
//  neggu
//
//  Created by 유지호 on 9/3/24.
//

import SwiftUI

public enum NegguFont {
    case title1
    case title2
    case title3
    case title4
    
    case body1
    case body1b
    case body2
    case body2b
    case body3
    case body3b
    
    case caption
    
    public var font: Font {
        switch self {
        case .title1, .title2, .title3, .title4, .body1b, .body2b, .body3b:
            NegguDSFontFamily.Pretendard.bold.swiftUIFont(size: fontSize)
        case .body3:
            NegguDSFontFamily.Pretendard.medium.swiftUIFont(size: fontSize)
        default:
            NegguDSFontFamily.Pretendard.regular.swiftUIFont(size: fontSize)
        }
    }
    
    public var fontName: String {
        switch self {
        case .title1, .title2, .title3, .title4, .body1b, .body2b, .body3b:
            return "Pretendard-Bold"
        case .body3:
            return "Pretendard-Regular"
        default:
            return "Pretendard-Medium"
        }
    }
    
    public var fontSize: CGFloat {
        switch self {
        case .title1: return 40.0
        case .title2: return 32.0
        case .title3: return 28.0
        case .title4: return 24.0
        case .body1, .body1b: return 20.0
        case .body2, .body2b: return 16.0
        case .body3, .body3b: return 14.0
        case .caption: return 12.0
        }
    }
    
    public var lineHeight: CGFloat {
        switch self {
        case .title1, .title2, .title3, .title4:
            return self.fontSize * 1.3
        default:
            return self.fontSize
        }
    }
    
    public var letterSpacing: CGFloat {
        switch self {
        case .title1, .title2, .title3, .title4:  
            return self.fontSize * -0.03
        default:
            return 0.0
        }
    }
}


public struct FontModifier: ViewModifier {
    private let font: NegguFont
    
    public init(_ font: NegguFont) {
        self.font = font
    }
    
    public func body(content: Content) -> some View {
        let fontHeight = font.fontSize
//        let lineHeight = font.lineHeight
        let letterSpacing = font.letterSpacing
        
        content
            .font(font.font)
            .kerning(letterSpacing)
//            .lineSpacing(lineHeight - fontHeight)
            .padding(.vertical, -(fontHeight * 0.3) / 2)
    }
}

public extension View {
    
    func negguFont(_ font: NegguFont) -> some View {
        modifier(FontModifier(font))
    }
    
}
