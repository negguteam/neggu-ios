//
//  OnboardingView.swift
//  neggu
//
//  Created by 유지호 on 11/12/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var tabIndex: Int = 0
    
    let onboardingList: [String] = [
        "네꾸와 함께\n디지털 옷장을\n시작해보세요",
        "내 옷들을\n한눈에\n모아보세요",
        "옷을 꺼내\n코디로\n만들 수 있어요",
        "친구에게\n코디를\n맡겨보세요"
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                HStack(spacing: 4) {
                    ForEach(onboardingList.indices, id: \.self) { index in
                        Capsule()
                            .fill(tabIndex == index ? .labelRAssistive : .white.opacity(0.2))
                            .frame(width: tabIndex == index ? 24 : 8, height: 8)
                            .onTapGesture {
                                tabIndex = index
                            }
                    }
                }
                .frame(height: 56)
                
                Text(onboardingList[tabIndex])
                    .negguFont(.title1)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
                    .toolbar(.hidden, for: .tabBar)
                
                Spacer()
                
                Button {
                    if tabIndex == onboardingList.count - 1 {
                        UserDefaultsKey.Auth.isFirstVisit = false
                    } else {
                        tabIndex += 1
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.black)
                        .frame(height: 56)
                        .overlay {
                            Text("다음으로")
                                .negguFont(.body1b)
                                .foregroundStyle(.labelRNormal)
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
            .background {
                Capsule()
                    .fill(.cyan)
                    .blur(radius: 100)
                    .offset(y: proxy.size.height - CGFloat(tabIndex) * proxy.size.height * 0.2)
            }
        }
        .background(Color.black)
        .animation(.smooth, value: tabIndex)
    }
}

#Preview {
    OnboardingView()
}
