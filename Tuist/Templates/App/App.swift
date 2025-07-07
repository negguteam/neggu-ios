//
//  App.swift
//  Templates
//
//  Created by 유지호 on 6/27/25.
//

import ProjectDescription

let appPath = "Projects/App"
let templatePath = "Tuist/Templates/"

let template = Template(
    description: "App Template",
    items: [
        .file(
            path: appPath + "/Project.swift",
            templatePath: "Project.stencil"
        ),
        .file(
            path: appPath + "/Sources/AppDelegate.swift",
            templatePath: .relativeToRoot(templatePath + "AppDelegate.stencil")
        ),
        .file(
            path: appPath + "/Sources/App.swift",
            templatePath: .relativeToRoot(templatePath + "App.stencil")
        ),
        .directory(
            path: appPath + "/Resources",
            sourcePath: .relativeToRoot(templatePath + "Assets.xcassets")
        ),
    ]
)
