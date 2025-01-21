//
//  OnboardingView.swift
//  neggu
//
//  Created by 유지호 on 11/12/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var scrollID: Int? = 0
    
    let onboardingList: [String] = [
        "네꾸와 함께 디지털 옷장을\n시작해보세요!",
        "내 옷장의 옷들로\n코디를 저장할 수 있어요",
        "친구에게 코디를\n부탁할 수 있어요"
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        ForEach(onboardingList.indices, id: \.self) { index in
                            Rectangle()
                                .fill(.gray10)
                                .frame(width: proxy.size.width)
                                .overlay {
                                    Text("\(index)")
                                }
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                }
                .frame(height: proxy.size.width)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $scrollID)
                
                HStack(spacing: 4) {
                    ForEach(onboardingList.indices, id: \.self) { index in
                        Capsule()
                            .fill(scrollID == index ? .labelNormal : .labelInactive)
                            .frame(width: scrollID == index ? 24 : 8, height: 8)
                            .onTapGesture {
                                scrollID = index
                            }
                    }
                }
                .frame(height: 56)
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(onboardingList[scrollID ?? 0])
                        .negguFont(.title2)
                        .foregroundStyle(.labelNormal)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button {
                        guard let scrollID else { return }
                        
                        if scrollID == onboardingList.count - 1 {
                            UserDefaultsKey.Auth.isFirstVisit = false
                        } else {
                            self.scrollID = scrollID + 1
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.negguSecondary)
                            .frame(height: 56)
                            .overlay {
                                Text(scrollID == onboardingList.count - 1 ? "시작하기" : "다음으로")
                                    .negguFont(.body1b)
                                    .foregroundStyle(.labelRNormal)
                            }
                    }
                    
                    if scrollID != 0 {
                        Button {
                            guard let scrollID else { return }
                            self.scrollID = scrollID - 1
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: "chevron.left")
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                
                                Text("이전으로")
                                    .negguFont(.body2)
                            }
                            .foregroundStyle(.labelAlt)
                            .frame(height: 24)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
                .padding(.bottom, 24)
            }
        }
        .animation(.smooth, value: scrollID)
    }
}

#Preview {
    OnboardingView()
}
