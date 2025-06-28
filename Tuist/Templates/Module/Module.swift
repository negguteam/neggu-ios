//
//  Module.swift
//  Templates
//
//  Created by 유지호 on 6/27/25.
//

import ProjectDescription

// 테스트가 있는지, 리소스가 있는지.
let nameAttribute: Template.Attribute = .required("name")

let template = Template(
    description: "Module Template",
    attributes: [
        nameAttribute
    ],
    items: ModuleTemplate.allCases.flatMap { $0.item }
)


enum ModuleTemplate: CaseIterable {
    case project, sources, derived, tests

    var basePath: String {
        "Projects/Modules/\(nameAttribute)"
    }
    
    var templatePath: String {
        "Tuist/Templates/"
    }
    
    var path: String {
        switch self {
        case .project:
            basePath
        case .sources:
            basePath + "/Sources"
        case .derived:
            basePath + "/Derived"
        case .tests:
            basePath + "/Tests"
        }
    }
    
    var item: [Template.Item] {
        switch self {
        case .project:
            [.file(path: path + "/Project.swift", templatePath: "Project.stencil")]
        case .sources: [.file(path: path + "/Empty.swift", templatePath: .relativeToRoot(templatePath + "Empty.stencil"))]
        case .derived:
            [.file(path: path + "/InfoPlists/Info.plist", templatePath: .relativeToRoot(templatePath + "Info.plist"))]
        case .tests:
            [.file(path: path + "/Sources/\(nameAttribute)Tests.swift", templatePath: .relativeToRoot(templatePath + "Tests.stencil"))]
        }
    }
}
