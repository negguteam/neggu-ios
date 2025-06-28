//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "ClosetFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    featureDependencies: [
        .Feature.Invite.interface
    ],
    interfaceDependencies: [
        .Feature.BaseFeature
    ],
    moduleDependencies: []
)
