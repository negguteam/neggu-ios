//
//  CategorySheet.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//

import Core
import NegguDS

import SwiftUI

struct CategorySheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var categorySelection: Core.Category
    @Binding var subCategorySelection: Core.SubCategory
    
    @State private var selectedCategory: Core.Category
    @State private var selectedSubCategory: Core.SubCategory
    
    init(categorySelection: Binding<Core.Category>, subCategorySelection: Binding<Core.SubCategory>) {
        self._categorySelection = categorySelection
        self._subCategorySelection = subCategorySelection
        self.selectedCategory = categorySelection.wrappedValue
        self.selectedSubCategory = subCategorySelection.wrappedValue
    }
    
    var body: some View {
        NegguSheet {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Core.Category.allCasesArray) { category in
                        DropDownButton(
                            selectedCategory: $selectedCategory,
                            selectedSubCategory: $selectedSubCategory,
                            category: category
                        )
                    }
                }
                .padding(.horizontal, 48)
                .padding(.bottom, 76)
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) {
                Button {
                    categorySelection = selectedCategory
                    subCategorySelection = selectedSubCategory
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            Text("선택완료")
                                .negguFont(.body1b)
                                .foregroundStyle(.labelRNormal)
                        }
                }
                .padding(.horizontal, 48)
                .padding(.top, 20)
                .background {
                    LinearGradient(
                        colors: [
                            Color(red: 248, green: 248, blue: 248, opacity: 0),
                            Color(red: 248, green: 248, blue: 248, opacity: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            }
        } header: {
            HStack {
                Text("옷의 종류")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if selectedCategory != .UNKNOWN {
                    Button {
                        selectedCategory = .UNKNOWN
                        selectedSubCategory = .UNKNOWN
                    } label: {
                        NegguImage.Icon.refresh
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
        }
    }
}

struct DropDownButton: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedCategory: Core.Category
    @Binding var selectedSubCategory: Core.SubCategory
    
    let category: Core.Category
    
    var isSelected: Bool {
        selectedCategory == category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                if selectedCategory == category {
                    selectedCategory = .UNKNOWN
                    selectedSubCategory = .UNKNOWN
                } else {
                    selectedCategory = category
                    selectedSubCategory = .UNKNOWN
                }
            } label: {
                HStack {
                    Text(category.title)
                        .negguFont(.body2)
                    
                    Spacer()
                    
                    NegguImage.Icon.chevronDown
                        .rotationEffect(isSelected ? .degrees(-90) : .degrees(0))
                }
                .foregroundStyle(selectedCategory == category ? .negguSecondary : .labelNormal)
                .frame(height: 52)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedCategory == category ? .negguSecondaryAlt : .clear)
                }
            }
            
            if isSelected {
                ForEach(category.subCategoryArray) { subCategory in
                    let subCategoryIsSelected = selectedSubCategory == subCategory
                    
                    Button {
                        if selectedSubCategory == subCategory {
                            selectedSubCategory = .UNKNOWN
                        } else {
                            selectedSubCategory = subCategory
                        }
                    } label: {
                        HStack {
                            Text(subCategory.title)
                                .negguFont(.body2)
                                .foregroundStyle(subCategoryIsSelected ? .negguSecondary : .labelAlt)
                            
                            Spacer()
                        }
                        .frame(height: 52)
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}
