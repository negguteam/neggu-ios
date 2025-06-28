//
//  SettingDictionary+Extension.swift
//
//  Created by 유지호 on 6/26/25.
//

import ProjectDescription

public extension SettingsDictionary {
    
    static let allLoadSettings: Self = [
        "OTHER_LDFLAGS" : [
            "$(inherited) -all_load",
            "-Xlinker -interposable"
        ]
    ]
    
    static let baseSettings: Self = [
        "OTHER_LDFLAGS" : [
            "$(inherited)",
            "-ObjC"
        ]
    ]
    
}
