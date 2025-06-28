//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "LookBookFeature",
    targets: [.staticFramework, .interface, .unitTest, .demo],
    featureDependencies: [
        .Feature.Invite.interface,
        .Feature.Setting.interface
    ],
    interfaceDependencies: [
        .Feature.BaseFeature
    ],
    moduleDependencies: []
)
