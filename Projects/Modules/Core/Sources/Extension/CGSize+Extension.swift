//
//  CGSize+Extension.swift
//  neggu
//
//  Created by 유지호 on 1/13/25.
//

import Foundation

public extension CGSize {
    
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
}
