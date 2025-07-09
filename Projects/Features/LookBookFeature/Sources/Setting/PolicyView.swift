//
//  PolicyView.swift
//  neggu
//
//  Created by 유지호 on 4/29/25.
//

import Core
import NegguDS

import BaseFeature

import SwiftUI

struct PolicyView: View {
    @StateObject private var router: PolicyRouter
    
    private let policyType: PolicyType
    
    init(router: PolicyRouter, _ policyType: PolicyType) {
        self._router = StateObject(wrappedValue: router)
        self.policyType = policyType
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    router.pop()
                } label: {
                    NegguImage.Icon.chevronLeft
                }
                .frame(width: 44, height: 44)
                
                Spacer()
                
                Text(policyType.title)
                
                Spacer()
                
                Color.clear
                    .frame(width: 44, height: 44)
            }
            .negguFont(.body1b)
            .foregroundStyle(.labelNormal)
            .frame(height: 44)
            .padding(.horizontal, 20)
            
            ScrollView {
//                Markdown(policyType.content)
//                    .negguFont(.body2)
//                    .foregroundStyle(.labelNormal)
//                    .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 48)
        }
    }
}
