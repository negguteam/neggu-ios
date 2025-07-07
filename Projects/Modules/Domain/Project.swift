//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Domain",
    targets: [.dynamicFramework, .unitTest],
    moduleDependencies: [
        .Module.Core.project
    ]
)
