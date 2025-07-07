//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "LookBookFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    featureDependencies: [
        .Feature.Closet.interface
    ],
    interfaceDependencies: [
        .Feature.BaseFeature
    ]
)
