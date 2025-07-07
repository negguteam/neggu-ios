//
//  UIImage+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/22/25.
//

import UIKit

public extension UIImage {
        
    func pixelColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        
        let width = 80
        let height = 80
//        let width = cgImage.width
//        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let pixelBuffer = context.data else { return nil }
        
        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        var colorDict: [UIColor: Int] = [:]
        
        for x in 0 ..< width {
            for y in 0 ..< height {
                let pixel = pointer[(y * width) + x]
                
                let r = CGFloat(red(for: pixel)) / 255.0
                let g = CGFloat(green(for: pixel)) / 255.0
                let b = CGFloat(blue(for: pixel)) / 255.0
                let alpha = CGFloat(alpha(for: pixel)) / 255.0
                                
                if r > 0.1 && g > 0.1 && b > 0.1 && alpha > 0 {
                    let color = UIColor(
                        red: r,
                        green: g,
                        blue: b,
                        alpha: alpha
                    )
                    
                    colorDict[color, default: 0] += 1
                }
            }
        }
        
        guard let mostColor = colorDict.max(by: { $0.value < $1.value })?.key else { return nil }
        return mostColor
    }
    
    func red(for color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }

    func green(for color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }

    func blue(for color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
    func alpha(for color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
}
