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
        .Feature.LookBook.project,
        .Feature.ImageSegment.project,
        .Feature.Invite.project,
        .Feature.Insight.project,
        .Feature.Setting.project
    ],
    interfaceDependencies: [],
    moduleDependencies: []
)
