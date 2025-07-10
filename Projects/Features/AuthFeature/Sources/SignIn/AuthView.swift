//
//  AuthView.swift
//  AuthFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import BaseFeature

import SwiftUI

public struct AuthView: View {
    @AppStorage("isFirstVisit") private var isFirstVisit: Bool = true
    
    @StateObject private var router: AuthRouter
    
    public init(router: AuthRouter) {
        self._router = StateObject(wrappedValue: router)
    }
    
    public var body: some View {
        NavigationStack(path: $router.routers) {
            router.start(isFirstVisit)
                .navigationDestination(for: AnyRoutable.self) { router in
                    if #available(iOS 18.0, *) {
                        router.makeView()
                            .toolbarVisibility(.hidden, for: .navigationBar)
                    } else {
                        router.makeView()
                            .toolbar(.hidden, for: .navigationBar)
                    }
                }
        }
    }
}
