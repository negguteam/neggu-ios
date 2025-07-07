//
//  MainCoordinatorable.swift
//  BaseFeature
//
//  Created by 유지호 on 6/30/25.
//  Copyright © 2025 Neggu. All rights reserved.
//

import SwiftUI

public protocol MainCoordinatorable: Coordinator {
    var activeTab: NegguTab { get set }
    var gnbState: GnbState { get set }
    var showGnb: Bool { get set }
    var isGnbOpened: Bool { get set }
}

public enum GnbState {
    case main
    case clothes
}
