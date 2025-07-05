//
//  ClothesEditType.swift
//  neggu
//
//  Created by 유지호 on 4/21/25.
//

import UIKit
import Domain

public enum ClothesEditType: Equatable, Hashable {
    case register(UIImage, ClothesRegisterEntity)
    case modify(ClothesEntity)
}
