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
                        LookBookDeleteCell(lookBook: lookBook)
                    }
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 56)
                        .onAppear {
                            print("LookBook Pagenation - onAppear")
                            viewModel.getLookBookList()
                        }
                }
                .padding(.horizontal, 48)
            }
            .scrollIndicators(.hidden)
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
    @State private var isSelected: Bool = false
    
    let lookBook: LookBookEntity
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isSelected ? .warningAlt : .white)
            .strokeBorder(isSelected ? .warning : .white)
            .overlay {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: lookBook.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Color.clear
                            .overlay {
                                ProgressView()
                            }
                    }

                    
                    Circle()
                        .fill(isSelected ? .warning : .bgAlt)
                        .frame(width: 24)
                }
                .padding(12)
            }
            .onTapGesture {
                isSelected.toggle()
            }
    }
}
