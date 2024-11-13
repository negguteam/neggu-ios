//
//  OnboardingView.swift
//  neggu
//
//  Created by 유지호 on 11/12/24.
//

import SwiftUI

struct OnboardingView: View {
    let onboardingList: [String] = [
        "네꾸와 함께 디지털 옷장을\n시작해보세요!",
        "내 옷장의 옷들로\n코디를 저장할 수 있어요",
        "친구에게 코디를\n부탁할 수 있어요"
    ]
    
    @State private var scrollID: Int? = 0
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(onboardingList.indices, id: \.self) { index in
                        Rectangle()
                            .fill(.gray10)
//                            .aspectRatio(1, contentMode: .fit)
                            .containerRelativeFrame(.horizontal)
                            .overlay {
                                Text("\(index)")
                            }
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .clipShape(.rect(cornerRadius: 51))
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $scrollID)
            
            VStack {
                HStack(spacing: 4) {
                    ForEach(onboardingList.indices, id: \.self) { index in
                        Capsule()
                            .fill(scrollID == index ? .black : .systemInactive)
                            .frame(width: scrollID == index ? 24 : 8, height: 8)
                            .onTapGesture {
                                scrollID = index
                            }
                    }
                }
                .padding(.vertical, 36)
                .animation(.smooth, value: scrollID)
                
                Text(onboardingList[scrollID ?? 0])
                    .negguFont(.title2)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.orange40)
                        .frame(height: 48)
                        .overlay {
                            Text(scrollID == onboardingList.count - 1 ? "시작하기" : "다음으로")
                                .negguFont(.body1b)
                                .foregroundStyle(.white)
                        }
                }
                .padding(.bottom, 28)
                
                if scrollID != 0 {
                    HStack {
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
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .background(.white)
    }
}

#Preview {
    OnboardingView()
}
