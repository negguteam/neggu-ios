//
//  Util.swift
//  neggu
//
//  Created by 유지호 on 8/4/24.
//

import SwiftUI

public enum Util {
    
    public static var deviceID: String {
        UIDevice.current.identifierForVendor!.uuidString
    }
    
    public static var deviceName: String {
        UIDevice.current.name
    }
    
    public static var appVersion: String {
        guard let info: [String: Any] = Bundle.main.infoDictionary,
              let currentVersion: String = info["CFBundleShortVersionString"] as? String 
        else { return "nil" }
        
        return currentVersion
    }
    
}
