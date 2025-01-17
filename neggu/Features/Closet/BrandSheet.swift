//
//  BrandSheet.swift
//  neggu
//
//  Created by 유지호 on 1/17/25.
//

import SwiftUI
import Combine

struct BrandSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var selectedBrand: String
    
    @State private var brandList: [BrandEntity] = []
    @State private var brandName: String = ""
    
    var filteredBrandList: [BrandEntity] {
        if brandName.isEmpty {
            brandList
        } else {
            brandList.filter { $0.en.lowercased().hasPrefix(brandName.lowercased()) }
        }
    }
    
    @State private var bag = Set<AnyCancellable>()
    
    let service = DefaultClosetService()
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 100)
                .fill(.black.opacity(0.1))
                .frame(width: 150, height: 8)
            
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
            
            HStack(spacing: 16) {
                Image(.link)
                    .foregroundStyle(.labelAssistive)
                    .padding(.leading, 12)
                
                TextField(
                    "",
                    text: $brandName,
                    prompt: Text("무신사, 에이블리, ...").foregroundStyle(.labelInactive)
                )
                .negguFont(.body2)
                .foregroundStyle(.labelNormal)
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.black)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.white)
                        }
                }
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.bgAlt)
                    .strokeBorder(.lineAlt)
            }
            
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(filteredBrandList) { brand in
                        let isSelected = selectedBrand == brand.en
                        
                        Button {
                            selectedBrand = brand.en
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
            }
        }
        .padding(.horizontal, 48)
        .padding(.top, 20)
        .onAppear {
            service.brandList()
                .sink { event in
                    print("Brand Sheet:", event)
                } receiveValue: { brandList in
                    self.brandList = brandList
                }.store(in: &bag)
        }
    }
}

#Preview {
    BrandSheet(selectedBrand: .constant(""))
}
