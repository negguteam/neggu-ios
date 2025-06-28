//
//  Configurations.swift
//  ProjectDescriptionHelpers
//
//  Created by 유지호 on 6/26/25.
//

import Foundation
import ProjectDescription

public enum XCConfig {

    struct Path {
        static let framework: ProjectDescription.Path = .relativeToRoot("Configurations/NegguKeys.xcconfig")
        static let demo: ProjectDescription.Path = .relativeToRoot("Configurations/NegguKeys.xcconfig")
        static let tests: ProjectDescription.Path = .relativeToRoot("Configurations/NegguKeys.xcconfig")
        static let project: ProjectDescription.Path = .relativeToRoot("Configurations/NegguKeys.xcconfig")
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.framework),
//        .debug(name: "Test", xcconfig: Path.framework),
//        .release(name: "QA", xcconfig: Path.framework),
        .release(name: "Release", xcconfig: Path.framework),
    ]
    
    public static let tests: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.tests),
//        .debug(name: "Test", xcconfig: Path.tests),
//        .release(name: "QA", xcconfig: Path.tests),
        .release(name: "Release", xcconfig: Path.tests),
    ]
    public static let demo: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.demo),
//        .debug(name: "Test", xcconfig: Path.demo),
//        .release(name: "QA", xcconfig: Path.demo),
        .release(name: "Release", xcconfig: Path.demo),
    ]
    public static let project: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.project),
//        .debug(name: "Test", xcconfig: Path.project("Test")),
//        .release(name: "QA", xcconfig: Path.project("QA")),
        .release(name: "Release", xcconfig: Path.project)
    ]
    
}
