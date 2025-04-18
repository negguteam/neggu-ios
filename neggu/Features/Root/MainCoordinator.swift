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
        case .clothesRegister(let segmentedImage, let clothes):
            ClothesRegisterView(segmentedImage: segmentedImage, clothes: clothes)
        case .clothesDetail(let id):
            ClothesDetailView(clothesID: id)
                .presentationDetents([.fraction(0.9)])
        case .categorySheet(let category, let subCategory):
            CategorySheet(selectedCategory: category, selectedSubCategory: subCategory)
                .presentationDetents([.fraction(0.85)])
        case .moodSheet(let mood, let isSingleSelection):
            MoodSheet(selectedMoodList: mood, isSingleSelection: isSingleSelection)
                .presentationDetents([.fraction(0.85)])
        case .colorSheet(let color):
            ColorSheet(selectedColor: color)
                .presentationDetents([.fraction(0.85)])
            
        case .lookbook:
            LookBookView()
        case .lookbookEdit(let inviteCode, let editingClothes):
            LookBookEditView(inviteCode: inviteCode, editingClothes: editingClothes)
        case .lookbookDetail(let lookBookID):
            LookBookDetailView(lookBookID: lookBookID)
            
        case .nicknameEdit(let nickname):
            NameEditView(name: nickname)
                .presentationDetents([.height(320)])
        case .insight:
            InsightView()
        case .setting:
            SettingView()
        }
    }
    
    enum Destination: Sceneable {
        case closet
        case clothesRegister(segmentedImage: UIImage, clothes: ClothesRegisterEntity)
        case clothesDetail(id: String)
        case categorySheet(category: Binding<Category>, SubCategory: Binding<SubCategory>)
        case moodSheet(mood: Binding<[Mood]>, isSingleSelection: Bool = false)
        case colorSheet(color: Binding<ColorFilter?>)
        
        case lookbook
        case lookbookEdit(inviteCode: String = "", editingClothes: [LookBookClothesItem] = [])
        case lookbookDetail(lookBookID: String)
        
        case nicknameEdit(nickname: String)
        case insight
        case setting
        
        var id: String { "\(self)" }
        
        static func == (lhs: MainCoordinator.Destination, rhs: MainCoordinator.Destination) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
