//
//  Coordinator.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import SwiftUI

typealias Sceneable = Identifiable & Hashable & Equatable

protocol Coordinator: ObservableObject {
    associatedtype Destination: Sceneable
    
    var path: NavigationPath { get set }
    var sheet: Destination? { get set }
    var fullScreenCover: Destination? { get set }
    
    func push(_ destination: Destination)
    func pop()
    func popToRoot()
    
    func present(_ destination: Destination)
    func fullScreenCover(_ destination: Destination)
    func dismiss()
}


extension Coordinator {
    
    var container: DIContainer { DIContainer.shared }
    
    // MARK: Navigation
    func push(_ destination: Destination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    
    // MARK: Present
    func present(_ destination: Destination) {
        sheet = destination
    }
    
    func fullScreenCover(_ destination: Destination) {
        fullScreenCover = destination
    }
     
    func dismiss() {
        sheet = nil
        fullScreenCover = nil
    }
    
    func dismissSheet() {
        sheet = nil
    }
    
    func dismissFullScreenCover() {
        fullScreenCover = nil
    }
    
}
