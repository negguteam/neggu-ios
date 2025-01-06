//
//  AuthCoordinator.swift
//  neggu
//
//  Created by 유지호 on 8/7/24.
//

import SwiftUI

final class AuthCoordinator: Coordinator {
    
    @Published var path: NavigationPath = .init()
    @Published public var sheet: Destination?
    @Published public var fullScreenCover: Destination?
    
    
    @ViewBuilder
    public func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .login:
            container.resolve(LoginView.self)
        case .signUp:
            container.resolve(SignUpView.self)
        case .complete:
            container.resolve(SignUpCompleteView.self)
        }
    }
    
    enum Destination: Sceneable {
        case login
        case signUp
        case complete
        
        var id: String { "\(self)" }
    }
    
}
