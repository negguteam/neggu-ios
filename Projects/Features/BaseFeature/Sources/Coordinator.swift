//
//  Coordinator.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import Core
import Domain

import SwiftUI

public typealias Sceneable = Identifiable & Hashable & Equatable

public enum MainScene: Sceneable {
    case clothesMain
    case clothesDetail(clothesId: String)
    case clothesRegister(entry: ClothesEditType)
    
    case clothesNameSheet(name: Binding<String>)
    case categorySheet(category: Binding<Core.Category>, subCategory: Binding<Core.SubCategory>)
    case moodSheet(selection: Binding<[Mood]>, isSingleSelection: Bool = false)
    case brandSheet(selection: Binding<String>, brandList: [BrandEntity])
    case colorSheet(selection: Binding<ColorFilter?>)
    
    case lookBookMain
    case lookBookDetail(id: String)
    case lookBookRegister
    
    case setting
    case policy(_ type: PolicyType)
    
    public var id: String { "\(self)" }
    
    public static func == (lhs: MainScene, rhs: MainScene) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public protocol Coordinator: ObservableObject {
    var path: NavigationPath { get set }
    var sheet: MainScene? { get set }
    var fullScreenCover: MainScene? { get set }
    
    func push(_ scene: MainScene)
    func pop()
    func popToRoot()
    
    func present(_ scene: MainScene)
    func presentFullScreen(_ scene: MainScene)
    func dismiss()
    func dismissFullScreen()
}


open class BaseCoordinator: Coordinator {
    
    @Published open var path: NavigationPath = .init()
    @Published open var sheet: MainScene?
    @Published open var fullScreenCover: MainScene?
    
    public init() { }
    
    
    // MARK: Navigation
    open func push(_ scene: MainScene) {
        path.append(scene)
    }
    
    open func pop() {
        path.removeLast(path.isEmpty ? 0 : 1)
    }
    
    open func popToRoot() {
        path.removeLast(path.count)
    }
    
    
    // MARK: Present
    open func present(_ scene: MainScene) {
        self.sheet = scene
    }
    
    open func presentFullScreen(_ scene: MainScene) {
        self.fullScreenCover = scene
    }
     
    open func dismiss() {
        self.sheet = nil
    }
    
    open func dismissFullScreen() {
        self.fullScreenCover = nil
    }
    
}
