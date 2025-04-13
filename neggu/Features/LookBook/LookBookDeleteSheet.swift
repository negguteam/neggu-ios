//
//  LookBookDeleteSheet.swift
//  neggu
//
//  Created by 유지호 on 3/1/25.
//

import SwiftUI

struct LookBookDeleteSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @State private var selectedLookBookList: [LookBookEntity] = []
    
    var body: some View {
        NegguSheet {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem](repeating: .init(.flexible(), spacing: 16), count: 2),
                    spacing: 16
                ) {
                    ForEach(viewModel.lookBookList) { lookBook in
                        let isSelected = selectedLookBookList.contains { $0.id == lookBook.id }
                        
                        LookBookDeleteCell(lookBook: lookBook, isSelected: isSelected)
                            .onTapGesture {
                                if isSelected {
                                    selectedLookBookList = selectedLookBookList.filter { $0.id != lookBook.id }
                                } else {
                                    selectedLookBookList.append(lookBook)
                                }
                            }
                    }
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 56)
                        .onAppear {
                            viewModel.getLookBookList()
                        }
                }
                .padding(.horizontal, 48)
                .padding(.bottom, viewModel.lookBookList.count % 2 == 0 ? 32 : 88)
            }
            .scrollIndicators(.hidden)
            .overlay(alignment: .bottom) {
                Button {
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(selectedLookBookList.isEmpty ? .bgInactive : .warning)
                        .frame(height: 56)
                        .overlay {
                            Text("선택완료")
                                .negguFont(.body1b)
                                .foregroundStyle(selectedLookBookList.isEmpty ? .labelInactive : .labelRNormal)
                        }
                }
                .disabled(selectedLookBookList.isEmpty)
                .padding(.horizontal, 48)
                .padding(.top, 20)
                .padding(.bottom)
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
                Text("삭제하기")
                    .negguFont(.title3)
                    .foregroundStyle(.warning)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(.xLarge)
                        .foregroundStyle(.labelAlt)
                }
            }
        }

    }
}

struct LookBookDeleteCell: View {
    let lookBook: LookBookEntity
    let isSelected: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isSelected ? .warningAlt : .white)
            .strokeBorder(isSelected ? .warning : .white)
            .frame(height: 220)
            .overlay {
                CachedAsyncImage(lookBook.imageUrl)
                    .padding(12)
            }
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(isSelected ? .warning : .bgAlt)
                    .frame(width: 24)
                    .overlay {
                        Image(.check)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(isSelected ? .white : .labelInactive)
                    }
                    .padding(12)
            }
    }
}
