//
//  TargetModule.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/27/25.
//

public enum TargetModule {
    case app
    case dynamicFramework
    case staticFramework
    case interface
    case unitTest
    case demo
    
    public var hasFramework: Bool {
        switch self {
        case .dynamicFramework, .staticFramework:
            return true
        default:
            return false
        }
    }
    
    public var hasDynamicFramework: Bool {
        self == .dynamicFramework
    }
}
