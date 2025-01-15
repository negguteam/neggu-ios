//
//  CategorySheet.swift
//  neggu
//
//  Created by 유지호 on 1/15/25.
//

import SwiftUI

struct CategorySheet: View {
    @Environment(\.dismiss) private var dismiss
    
    // 뷰모델로 개선하기
    @Binding var selectedCategory: Category?
    @Binding var selectedSubCategory: SubCategory?
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
            
            HStack {
                Text("카테고리")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if selectedCategory != nil {
                    Button {
                        selectedCategory = nil
                        selectedSubCategory = nil
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Category.allCasesArray) { category in
                        DropDownButton(
                            selectedCategory: $selectedCategory,
                            selectedSubCategory: $selectedSubCategory,
                            category: category
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 48)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    ContentView()
}


struct DropDownButton: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedCategory: Category?
    @Binding var selectedSubCategory: SubCategory?
    
    let category: Category
    
    var isSelected: Bool {
        selectedCategory == category
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                if selectedCategory == category {
                    selectedCategory = nil
                } else {
                    selectedCategory = category
                    selectedSubCategory = nil
                }
            } label: {
                HStack {
                    Text(category.rawValue)
                        .negguFont(.body2)
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "chevron.right" : "chevron.down")
                }
                .foregroundStyle(setContentColor())
                .frame(height: 52)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(setBackgroundColor())
                }
            }
            
            if isSelected {
                ForEach(category.subCategoryArray) { subCategory in
                    let subCategoryIsSelected = selectedSubCategory == subCategory
                    Button {
                        if selectedSubCategory == subCategory {
                            selectedSubCategory = nil
                        } else {
                            selectedSubCategory = subCategory
                            dismiss()
                        }
                    } label: {
                        HStack {
                            Text(subCategory.rawValue)
                                .foregroundStyle(subCategoryIsSelected ? .negguSecondary : .labelAlt)
                            
                            Spacer()
                        }
                        .frame(height: 52)
                        .padding(.horizontal, 24)
                    }
                }
            }
        }
        .animation(.smooth, value: isSelected)
    }
    
    func setContentColor() -> Color {
        if selectedCategory == category && selectedSubCategory == nil {
            return .negguSecondary
        } else {
            return .labelNormal
        }
    }
    
    func setBackgroundColor() -> Color {
        if selectedCategory == category && selectedSubCategory == nil {
            return .negguSecondaryAlt
        } else {
            return .clear
        }
    }
}
