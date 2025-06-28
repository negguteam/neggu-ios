//
//  UIColor+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import UIKit

public extension UIColor {
    
    func toHex(includeAlpha: Bool = false) -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }
    
    func toRGB() -> (r: Int, g: Int, b: Int)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
}
