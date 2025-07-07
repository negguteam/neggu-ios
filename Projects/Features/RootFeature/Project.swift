//
//  Project.swift
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.createModule(
    name: "RootFeature",
    targets: [.staticFramework, .demo],
    featureDependencies: [
        .Feature.Auth.project,
        .Feature.Closet.project,
        .Feature.LookBook.project
    ],
    interfaceDependencies: [],
    moduleDependencies: []
)
