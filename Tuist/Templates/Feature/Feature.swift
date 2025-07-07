//
//  Feature.swift
//  Templates
//
//  Created by 유지호 on 6/27/25.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Feature Template",
    attributes: [
        nameAttribute
    ],
    items: FeatureTemplate.allCases.flatMap { $0.item }
)


enum FeatureTemplate: CaseIterable {
    case project, interface, sources, tests, derived, demo

    var basePath: String {
        "Projects/Features/\(nameAttribute)Feature"
    }
    
    var templatePath: String {
        "Tuist/Templates/"
    }
    
    var path: String {
        switch self {
        case .project:
            basePath
        case .interface:
            basePath + "/Interface"
        case .sources:
            basePath + "/Sources"
        case .tests:
            basePath + "/Tests"
        case .derived:
            basePath + "/Derived"
        case .demo:
            basePath + "/Demo"
        }
    }
    
    var item: [Template.Item] {
        switch self {
        case .project:
            [.file(path: path + "/Project.swift", templatePath: "Project.stencil")]
        case .interface:
            [.file(path: path + "/Sources/Empty.swift", templatePath: .relativeToRoot(templatePath + "Empty.stencil"))]
        case .sources:
            [.file(path: path + "/Empty.swift", templatePath: .relativeToRoot(templatePath + "Empty.stencil"))]
        case .tests:
            [.file(
                path: path + "/Sources/\(nameAttribute)FeatureTests.swift",
                templatePath: .relativeToRoot(templatePath + "Tests.stencil")
            )]
        case .derived:
            [.file(path: path + "/InfoPlists/Info.plist", templatePath: .relativeToRoot(templatePath + "Info.plist"))]
        case .demo:
            [.file(
                path: path + "/Sources/AppDelegate.swift",
                templatePath: .relativeToRoot(templatePath + "AppDelegate.stencil")
            ),
             .directory(
                path: path + "/Resources",
                sourcePath: .relativeToRoot(templatePath + "Assets.xcassets")
             )]
        }
    }
}
