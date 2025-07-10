//
//  TabRouter.swift
//  RootFeature
//
//  Created by 유지호 on 7/8/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

import BaseFeature
import ClosetFeature
import LookBookFeature

public final class TabRouter: TabRoutable {
   
    @Published public var activeTab: NegguTab = .closet
    @Published public var gnbState: GnbState = .main
    @Published public var showGnb: Bool = true
    @Published public var isGnbOpened: Bool = false
    
    private let closetBuilder = ClosetFeatureBuilder()
    private let lookBookBuilder = LookBookFeatureBuilder()
    
    public init() { }
    
    deinit {
        debugPrint("\(self) deinit")
    }
    
    
    public func startClosetFlow() -> ClosetRouter {
        let router = ClosetRouter(
            tabRouter: self,
            closetBuilder: closetBuilder
        )
        return router
    }
    
    public func startLookBookFlow() -> LookBookMainRouter {
        let router = LookBookMainRouter(
            tabRouter: self,
            lookBookBuilder: lookBookBuilder,
            closetBuilder: closetBuilder
        )
        return router
    }
    
    public func switchTab(_ tab: NegguTab) {
        if activeTab == tab { return }
        activeTab = tab
    }
    
}
