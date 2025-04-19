//
//  NegguInviteAlert.swift
//  neggu
//
//  Created by 유지호 on 3/9/25.
//

import SwiftUI

struct NegguInviteAlert: View {
    @EnvironmentObject private var viewModel: LookBookViewModel
    
    @Binding var showAlert: Bool
    
    @State private var inviteCode = ""
    @State private var showCompletion: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                GradientView {
                    Image(.negguStar)
                }
                
                GradientView {
                    Text("네가 좀 꾸며줘")
                        .negguFont(.body1b)
                }
                
                Spacer()
                
                Button {
                    showAlert = false
                } label: {
                    Image(.xLarge)
                        .foregroundStyle(.labelRAssistive)
                }
            }
            
            HStack(spacing: 0) {
                Text("초대코드")
                    .negguFont(.body3b)
                
                Text("를 친구에게 공유해보세요!")
                    .negguFont(.body3)
                
                Spacer()
            }
            .foregroundStyle(.labelRNormal)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray70)
                .frame(height: 36)
                .overlay {
                    HStack(spacing: 12) {
                        Text("내 초대코드")
                        
                        Text(inviteCode)
                        
                        Spacer()
                        
                        Button {
                            UIPasteboard.general.string = inviteCode
                            showCompletion = true
                        } label: {
                            Image(.tablerCopy)
                                .foregroundStyle(.labelInactive)
                        }
                    }
                    .negguFont(.body3b)
                    .foregroundStyle(.white)
                    .padding(.leading)
                    .padding(.trailing, 8)
                }
            
            HStack(spacing: 16) {
                Button {
                    print("Share to X")
                } label: {
                    Image(.xLogo)
                        .frame(width: 48, height: 48)
                }
                
                Button {
                    print("Share to KakaoTalk")
                } label: {
                    Image(.kakaotalkLogo)
                        .frame(width: 48, height: 48)
                }
                
                Button {
                    print("Share to Instagram")
                } label: {
                    Image(.instagramLogo)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 28)
        .background {
            RoundedRectangle(cornerRadius: 20)
        }
        .overlay {
            if showCompletion {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.bgDimmed)
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.negguSecondary)
                        .frame(height: 56)
                        .overlay {
                            HStack {
                                Text("클립 보드에 복사되었습니다")
                                    .negguFont(.body2b)
                                    .foregroundStyle(.labelRNormal)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.horizontal, 34)
                        .padding(.bottom)
                }
                .onAppear {
                    Task {
                        try await Task.sleep(for: .seconds(1))
                        showCompletion = false
                    }
                }
            }
        }
        .padding(2)
        .background {
            Image(.gnbOpen)
                .resizable()
                .clipShape(.rect(cornerRadius: 20))
        }
        .padding(.horizontal, 48)
        .animation(.easeInOut, value: showCompletion)
        .onAppear {
            viewModel.send(action: .generateNeggu(completion: { result in
                inviteCode = result.id
            }))
        }
    }
}
