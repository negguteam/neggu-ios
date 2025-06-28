//
//  Project+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/26/25.
//

import Foundation
import ProjectDescription

public extension Project {
    
    static func createModule(
        name: String,
        targets: Set<TargetModule> = Set([.staticFramework, .interface, .unitTest, .demo]),
        packages: [Package] = [],
        featureDependencies: [TargetDependency] = [],
        interfaceDependencies: [TargetDependency] = [],
        moduleDependencies: [TargetDependency] = [],
        externalDependencies: [TargetDependency] = [],
        hasResource: Bool = false
    ) -> Project {
        let hasDynamicFramework = targets.contains(.dynamicFramework)
        
        let baseSettings: SettingsDictionary = .baseSettings
        let configurationName: ConfigurationName = "Develop"
        
        var projectTargets: [Target] = []
        
        
        // MARK: App
        
        if targets.contains(.app) {
            let settings = baseSettings
            
            let target = Target.target(
                name: name,
                destinations: Self.destinations,
                product: .app,
                bundleId: Self.bundlePrefix + "release",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .extendingDefault(with: Self.defaultInfoPlist),
                sources: ["Sources/**"],
                resources: [.glob(pattern: "Resources/**")],
                entitlements: "\(name).entitlements",
                dependencies: featureDependencies + moduleDependencies + externalDependencies,
                settings: .settings(base: baseSettings, configurations: XCConfig.project)
            )
            
            projectTargets.append(target)
        }
        
        
        // MARK: Feature Interface
        
        if targets.contains(.interface) {
            let settings = baseSettings
            
            let target = Target.target(
                name: name + "Interface",
                destinations: Self.destinations,
                product: .framework,
                bundleId: Self.bundlePrefix + "\(name)Interface",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .default,
                sources: ["Interface/Sources/**"],
                dependencies: interfaceDependencies,
                settings: .settings(base: settings, configurations: XCConfig.framework)
            )
            
            projectTargets.append(target)
        }
        
        
        // MARK: Framework
        
        if targets.contains(where: { $0.hasFramework }) {
            let settings = baseSettings
            let deps: [TargetDependency] = targets.contains(.interface)
            ? [.target(name: "\(name)Interface")]
            : []
            
            let target = Target.target(
                name: name,
                destinations: Self.destinations,
                product: hasDynamicFramework ? .framework : .staticFramework,
                bundleId: Self.bundlePrefix + name,
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: hasResource ? [.glob(pattern: "Resources/**")] : [],
                dependencies: deps + featureDependencies + moduleDependencies + externalDependencies,
                settings: .settings(base: settings, configurations: XCConfig.framework)
            )
            
            projectTargets.append(target)
        }
        
        
        // MARK: Tests
        
        if targets.contains(.unitTest) {
            let settings = baseSettings
            
            let target = Target.target(
                name: name + "Tests",
                destinations: Self.destinations,
                product: .unitTests,
                bundleId: Self.bundlePrefix + "\(name)Tests",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .default,
                sources: ["Tests/Sources/**"],
                dependencies: [.target(name: name)],
                settings: .settings(base: settings, configurations: XCConfig.tests)
            )
            
            projectTargets.append(target)
        }
        
        
        // MARK: Demo
        
        if targets.contains(.demo) {
            let target = Target.target(
                name: name + "Demo",
                destinations: Self.destinations,
                product: .app,
                bundleId: Self.bundlePrefix + "\(name)Demo",
                deploymentTargets: Self.deploymentTarget,
                infoPlist: .extendingDefault(with: Self.demoInfoPlist),
                sources: ["Demo/Sources/**"],
                resources: [.glob(pattern: "Demo/Resources/**")],
                dependencies: [.target(name: name)],
                settings: .settings(base: baseSettings, configurations: XCConfig.demo)
            )
            
            projectTargets.append(target)
        }
        
        
        // MARK: Scheme
        
        let schemes: [Scheme] = targets.contains(.demo)
        ? [.createScheme(name: name, config: configurationName), .createDemoScheme(name: name, config: configurationName)]
        : [.createScheme(name: name, config: configurationName)]
        
        return .init(
            name: name,
            organizationName: Self.workspaceName,
            packages: packages,
            settings: .settings(base: baseSettings),
            targets: projectTargets,
            schemes: schemes
        )
    }
    
}
