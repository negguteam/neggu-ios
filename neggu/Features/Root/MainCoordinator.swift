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
            container.resolve(ClosetView.self)
        case .clothesDetail(let id):
            container.resolve(ClothesDetailView.self, parameter: id)
                .presentationDetents([.fraction(0.9)])
        case .clothesRegister(let editType):
            container.resolve(ClothesRegisterView.self, parameter: editType)
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
            container.resolve(LookBookMainView.self)
        case .lookbookDetail(let lookBookID):
            container.resolve(LookBookDetailView.self, parameter: lookBookID)
        case .lookbookRegister(let code, let clothes):
            container.resolve(LookBookRegisterView.self, parameters: code, clothes)
        case .lookbookDelete:
            LookBookDeleteSheet()
                .presentationDetents([.fraction(0.8)])
        case .lookbookDateSheet(let date):
            LookBookDateSheet(selectedDate: date)
            
        case .nicknameEdit(let nickname):
            NameEditView(name: nickname)
                .presentationDetents([.height(320)])
        case .insight:
            InsightView()
        case .setting:
            SettingView()
        case .webView(let url):
            CustomWebView(url: url)
        }
    }
    
    enum Destination: Sceneable {
        case closet
        case clothesDetail(id: String)
        case clothesRegister(ClothesEditType)
        case categorySheet(category: Binding<Category>, SubCategory: Binding<SubCategory>)
        case moodSheet(mood: Binding<[Mood]>, isSingleSelection: Bool = false)
        case colorSheet(color: Binding<ColorFilter?>)
        
        case lookbook
        case lookbookDetail(lookBookID: String)
        case lookbookRegister(inviteCode: String = "", editingClothes: [LookBookClothesItem] = [])
        case lookbookDelete
        case lookbookDateSheet(date: Binding<Date?>)
        
        case nicknameEdit(nickname: String)
        case insight
        case setting
        case webView(url: String)
        
        var id: String { "\(self)" }
        
        static func == (lhs: MainCoordinator.Destination, rhs: MainCoordinator.Destination) -> Bool {
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }
}
