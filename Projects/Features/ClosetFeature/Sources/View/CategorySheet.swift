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
    
    @Binding var selectedCategory: Core.Category
    @Binding var selectedSubCategory: Core.SubCategory
    
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
            }
            .scrollIndicators(.hidden)
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
                        dismiss()
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
                            dismiss()
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
