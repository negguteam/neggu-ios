//
//  StyleAnalyzeButton.swift
//  neggu
//
//  Created by 유지호 on 4/19/25.
//

import SwiftUI

struct StyleAnalyzeButton: View {
    let buttonAction: () -> Void
    
    var body: some View {
        Button {
            buttonAction()
        } label: {
            RoundedRectangle(cornerRadius: 20)
                .fill(.negguPrimary)
                .frame(height: 56)
                .overlay {
                    HStack {
                        Image("neggu_star")
                            .frame(width: 24, height: 24)
                        
                        Text("내 취향분석 더 보기")
                            .negguFont(.body2b)
                        
                        Image(.chevronRight)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.labelRAssistive)
                            .frame(width: 12, height: 12)
                    }
                    .foregroundStyle(.labelRNormal)
                }
                .overlay(alignment: .topTrailing) {
                    Image("lookbook_favorite_top")
                    
                    Image("lookbook_favorite_bottom")
                }
        }
    }
}
