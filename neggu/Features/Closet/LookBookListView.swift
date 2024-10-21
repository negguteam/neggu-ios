//
//  LookBookListView.swift
//  neggu
//
//  Created by 유지호 on 10/20/24.
//

import SwiftUI

struct LookBookListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Circle()
                        .fill(.gray10)
                        .frame(width: 64)
                    
                    Spacer()
                    
                    HStack {
                        Text("내 취향 더보기")
                        
                        Image(systemName: "arrow.right")
                    }
                    .negguFont(.body3b)
                    .foregroundStyle(.orange40)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.orange10)
                    }
                    
                    Image(systemName: "gear")
                }
                
                Text("길동의 룩북")
                    .negguFont(.title2)
                
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
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 16) {
                LazyVStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .frame(height: 283)
                            .overlay {
                                VStack(alignment: .trailing) {
                                    Image(systemName: "pin.fill")
                                    
                                    ProgressView()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .padding()
                            }
                    }
                }
                
                LazyVStack(spacing: 16) {
                    ForEach(0..<3, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .frame(height: 283)
                            .overlay {
                                VStack(alignment: .trailing) {
                                    Image(systemName: "pin.fill")
                                    
                                    ProgressView()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                                .padding()
                            }
                    }
                }
                .padding(.top, 80)
            }
            .padding()
        }
        .background(.gray5)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    LookBookListView()
}
