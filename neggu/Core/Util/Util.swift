//
//  Util.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import SwiftUI

enum Util {
    
    static var deviceID: String {
        UIDevice.current.identifierForVendor!.uuidString
    }
    
    static var appVersion: String {
        guard let info: [String: Any] = Bundle.main.infoDictionary,
              let currentVersion: String = info["CFBundleShortVersionString"] as? String 
        else { return "nil" }
        
        return currentVersion
    }
    
}
