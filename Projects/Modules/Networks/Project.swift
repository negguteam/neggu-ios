//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "Networks",
    targets: [.staticFramework, .unitTest],
    moduleDependencies: [
        .Module.Core.project
    ]
)
