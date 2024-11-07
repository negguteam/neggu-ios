//
//  LookBookListView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI

struct LookBookListView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        HStack(spacing: 4) {
                            Text("취향 분석")
                            
                            Image(systemName: "arrow.right")
                        }
                        .negguFont(.body3b)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.black)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .frame(width: 18, height: 18)
                        
                        Image(.setting)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Circle()
                            .fill(.gray10)
                            .frame(width: 109)
                            .padding(.bottom)
                        
                        Text("아메카지 러버")
                            .negguFont(.body2b)
                            .foregroundStyle(.gray40)
                        
                        Text("길동의 룩북")
                            .negguFont(.title2)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("곧 입을 룩북")
                            .negguFont(.title3)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                ForEach(0..<3, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white)
                                        .frame(width: 220, height: 320)
                                        .overlay {
                                            VStack {
                                                Image(.dummyLookbook)
                                                    .resizable()
                                                    .scaledToFit()
                                                
                                                Text("날짜 \(index)")
                                                    .negguFont(.body3b)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 10)
                                                    .foregroundStyle(.white)
                                                    .background {
                                                        Capsule()
                                                    }
                                            }
                                            .padding()
                                        }
                                }
                            }
                            .padding(.horizontal, 48)
                        }
                        .padding(.horizontal, -20)
                    }
                    .padding(.bottom)
                    
                    Text("모든 룩북")
                        .negguFont(.title3)
                    
                    HStack {
                        Text("최신순")
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray10)
                            }
                        
                        Text("분위기")
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.gray10)
                            }
                        
                        Spacer()
                    }
                    .negguFont(.body3b)
                    .foregroundStyle(.gray50)
                    
                    LazyVGrid(
                        columns: [GridItem](repeating: GridItem(.flexible(), spacing: 16), count: 2),
                        spacing: 16
                    ) {
                        ForEach(0..<8, id: \.self) { index in
                            NavigationLink {
                                LookBookView()
                            } label: {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .frame(height: 283)
                                    .overlay {
                                        VStack(alignment: .trailing) {
                                            Image(systemName: "pin.fill")
                                            
                                            Image("dummy_lookbook")
                                                .resizable()
                                                .scaledToFit()
                                        }
                                        .padding()
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
            .background(.gray5)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        LookBookListView()
    }
}
