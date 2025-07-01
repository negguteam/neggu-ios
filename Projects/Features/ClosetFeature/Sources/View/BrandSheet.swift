//
//  BrandSheet.swift
//  neggu
//
//  Created by 유지호 on 1/17/25.
//

import Core
import NegguDS
import Networks

import SwiftUI
import Combine

struct BrandSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedBrand: String
    
    @State private var brandList: [BrandEntity]
    @State private var brandName: String = ""
    
    var filteredBrandList: [BrandEntity] {
        if brandName.isEmpty {
            brandList
        } else {
            brandList.filter { $0.en.lowercased().hasPrefix(brandName.lowercased()) }
        }
    }
    
    init(selectedBrand: Binding<String>, brandList: [BrandEntity]) {
        self._selectedBrand = selectedBrand
        self.brandList = brandList
    }
    
    var body: some View {
        NegguSheet {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    NegguImage.Icon.search
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.labelAssistive)
                        .padding(.leading, 8)
                    
                    TextField(
                        "",
                        text: $brandName,
                        prompt: Text("무신사, 에이블리, ...").foregroundStyle(.labelInactive)
                    )
                    .negguFont(.body2)
                    .foregroundStyle(.labelNormal)
                    
                    Button {
                        brandName.removeAll()
                    } label: {
                        NegguImage.Icon.smallX
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.labelAlt)
                    }
                    .opacity(brandName.isEmpty ? 0 : 1)
                    .disabled(brandName.isEmpty)
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.bgAlt)
                        .strokeBorder(.lineAlt)
                }
                .padding(.horizontal, 48)
                
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(filteredBrandList) { brand in
                            let isSelected = selectedBrand == brand.en
                            
                            Button {
                                selectedBrand = brand.en
                                dismiss()
                            } label: {
                                HStack {
                                    Text(brand.en)
                                        .negguFont(.body2)
                                        .foregroundStyle(isSelected ? .negguSecondary : .labelAlt)
                                    
                                    Spacer()
                                }
                                .frame(height: 52)
                                .padding(.horizontal, 12)
                            }
                        }
                    }
                    .padding(.horizontal, 48)
                }
                .scrollIndicators(.hidden)
            }
        } header: {
            HStack {
                Text("브랜드")
                    .negguFont(.title3)
                    .foregroundStyle(.labelNormal)
                
                Spacer()
                
                if !selectedBrand.isEmpty {
                    Button {
                        selectedBrand.removeAll()
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.labelAssistive)
                    }
                }
            }
        }
    }
}
