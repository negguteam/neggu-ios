//
//  MainCoordinator.swift
//  neggu
//
//  Created by 유지호 on 1/7/25.
//

import SwiftUI

final class MainCoordinator: Coordinator {
    
    @Published var activeTab: NegguTab = .closet
    @Published var showGnb: Bool = true
    
    @Published var isGnbOpened: Bool = false
    
    @Published var path: NavigationPath = .init()
    
    @Published var closetPath: NavigationPath = .init() {
        didSet {
            print("Closet Path:", closetPath.count)
            showGnb = closetPath.isEmpty
        }
    }
    
    @Published var lookbookPath: NavigationPath = .init() {
        didSet {
            print("LookBook Path:", lookbookPath.count)
            showGnb = lookbookPath.isEmpty
        }
    }
    
    @Published var sheet: Destination? {
        didSet {
            print("Sheet:", sheet?.id ?? "none")
        }
    }
    
    @Published var fullScreenCover: Destination? {
        didSet {
            print("FullScreen Cover:", fullScreenCover?.id ?? "none")
        }
    }
    
    
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
        case .clothesDetail(let clothesID):
            ClothesDetailView(clothesID: clothesID)
        
        case .lookbook:
            LookBookView()
        case .lookbookEdit(let editingClothes):
            LookBookEditView(editingClothes: editingClothes)
        case .lookbookDetail(let lookBookID):
            LookBookDetailView(lookBookID: lookBookID)
            
        case .insight:
            InsightView()
        case .setting:
            SettingView()
        }
    }
    
    enum Destination: Sceneable {
        case closet
        case closetAdd(clothes: ClothesRegisterEntity, segmentedImage: UIImage)
        case clothesDetail(clothesID: String)
        
        case lookbook
        case lookbookEdit(editingClothes: [LookBookClothesItem] = [])
        case lookbookDetail(lookBookID: String)
        
        case insight
        case setting
        
        var id: String { "\(self)" }
    }
}
