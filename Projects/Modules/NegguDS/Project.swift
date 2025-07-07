//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "NegguDS",
    targets: [.dynamicFramework],
    moduleDependencies: [
        .Module.Core.project
    ],
    hasResource: true
)
