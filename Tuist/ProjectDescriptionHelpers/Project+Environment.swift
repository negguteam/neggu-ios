//
//  Project+Environment.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/26/25.
//

import Foundation
import ProjectDescription

public extension Project {
    
    static let workspaceName = "Neggu"
    static let deploymentTarget = DeploymentTargets.iOS("17.0")
    static let destinations: Destinations = [Destination.iPhone]
    static let bundlePrefix = "com.Neggu."
    
}


// MARK: Info.plist

public extension Project {
    
    static let defaultInfoPlist: [String: Plist.Value] = [
        "CFBundleIdentifier": .string(bundlePrefix + "release"),
        "CFBundleDisplayName": .string("네꾸"),
        "UIUserInterfaceStyle": .string("Light"),
        "UIBackgroundModes": .array([
            .string("remote-notification"),
            .string("fetch")
        ]),
        "UIAppFonts": .array([]),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([:])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "NSCameraUsageDescription": .string("의상을 촬영하려면 카메라 권한이 필요합니다."),
    ]
    
    static let demoInfoPlist: [String: Plist.Value] = [
        "CFBundleIdentifier": .string(bundlePrefix + "demo"),
        "CFBundleDisplayName": .string("네꾸-Demo"),
        "UIUserInterfaceStyle": .string("Light"),
        "UIBackgroundModes": .array([
            .string("remote-notification"),
            .string("fetch")
        ]),
        "UIAppFonts": .array([]),
        "UILaunchStoryboardName": .string("LaunchScreen"),
        "UIApplicationSceneManifest": .dictionary([
            "UIApplicationSupportsMultipleScenes": .boolean(false),
            "UISceneConfigurations": .dictionary([:])
        ]),
        "NSAppTransportSecurity": .dictionary([
            "NSAllowsArbitraryLoads": .boolean(true)
        ]),
        "NSCameraUsageDescription": .string("의상을 촬영하려면 카메라 권한이 필요합니다."),
    ]
        
}
