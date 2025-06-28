//
//  Project.swift
//
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: Project.workspaceName,
    targets: [.app],
    featureDependencies: [
        .Feature.RootFeature
    ],
    moduleDependencies: [],
    externalDependencies: []
)
