//
//  Project+Scheme.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/27/25.
//

import ProjectDescription

public extension Scheme {
    
    static func createScheme(name: String, config: ConfigurationName) -> Scheme {
        return Scheme.scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: config,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: config)
        )
    }
    
    static func createDemoScheme(name: String, config: ConfigurationName) -> Scheme {
        return Scheme.scheme(
            name: name + "Demo",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            runAction: .runAction(configuration: config)
        )
    }
    
}
