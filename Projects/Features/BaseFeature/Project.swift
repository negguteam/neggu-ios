//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "BaseFeature",
    targets: [.dynamicFramework],
    featureDependencies: [],
    interfaceDependencies: [],
    moduleDependencies: [
        .Module.NegguDS.project,
        .Module.Networks.project
    ]
)
