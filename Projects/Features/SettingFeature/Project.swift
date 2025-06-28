//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "SettingFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    featureDependencies: [],
    interfaceDependencies: [
        .Feature.BaseFeature
    ],
    moduleDependencies: []
)
