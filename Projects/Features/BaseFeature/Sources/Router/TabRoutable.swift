//
//  TabRoutable.swift
//  BaseFeature
//
//  Created by 유지호 on 7/10/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import Combine

public protocol TabRoutable: ObservableObject {
    var activeTab: NegguTab { get set }
    var gnbState: GnbState { get set }
    var showGnb: Bool { get set }
    var isGnbOpened: Bool { get set }
    
    func switchTab(_ tab: NegguTab)
}
