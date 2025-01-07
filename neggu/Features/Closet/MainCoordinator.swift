//
//  MainCoordinator.swift
//  neggu
//
//  Created by 유지호 on 1/7/25.
//

import SwiftUI

final class MainCoordinator: Coordinator {
    
    @Published var activeTab: NegguTab = .closet
    @Published var showTabbar: Bool = true
    @Published var showTabbarList: Bool = false
    
    @Published var path: NavigationPath = .init()
    
    @Published var closetPath: NavigationPath = .init() {
        didSet {
            print("Closet Path:", closetPath.count)
            showTabbar = closetPath.isEmpty
        }
    }
    
    @Published var lookbookPath: NavigationPath = .init() {
        didSet {
            print("LookBook Path:", lookbookPath.count)
            showTabbar = lookbookPath.isEmpty
        }
    }
    
    @Published var sheet: Destination?
    @Published var fullScreenCover: Destination?
    
    
    func push(_ destination: Destination) {
        switch activeTab {
        case .closet:
            closetPath.append(destination)
        case .lookbook:
            lookbookPath.append(destination)
        }
    }
    
    func pop() {
        switch activeTab {
        case .closet:
            closetPath.removeLast()
        case .lookbook:
            lookbookPath.removeLast()
        }
    }
    
    @ViewBuilder
    func buildScene(_ scene: Destination) -> some View {
        switch scene {
        case .closet:
            ClosetView()
        case .closetAdd(let clothes, let segmentedImage):
            ClosetAddView(clothes: clothes, segmentedImage: segmentedImage)
        case .clothesDetail(let clothes):
            ClothesDetailView(clothes: clothes)
        
        case .lookbookList:
            LookBookListView()
        case .lookbookEdit:
            LookBookEditView()
        case .lookbookDetail:
            LookBookDetailView()
        }
    }
    
    enum Destination: Sceneable {
        case closet
        case closetAdd(clothes: Clothes, segmentedImage: UIImage)
        case clothesDetail(clothes: Clothes)
        
        case lookbookList
        case lookbookEdit
        case lookbookDetail
        
        var id: String { "\(self)" }
    }
    
}
