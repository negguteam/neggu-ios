//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "InsightFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    featureDependencies: [],
    interfaceDependencies: [
        .Feature.BaseFeature
    ],
    moduleDependencies: []
)
