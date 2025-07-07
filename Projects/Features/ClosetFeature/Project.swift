//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "ClosetFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    interfaceDependencies: [
        .Feature.BaseFeature
    ]
)
