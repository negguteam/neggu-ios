//
//  NegguCTAButton.swift
//  neggu
//
//  Created by 유지호 on 1/14/25.
//

import SwiftUI
import Combine

struct NegguCTAButton: View {
    @EnvironmentObject private var coordinator: MainCoordinator
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @EnvironmentObject private var lookBookViewModel: LookBookViewModel
    
    @Binding var isExpanded: Bool
    
    @State private var negguState: NegguState = .main
    
    @State private var generatedInviteCode: String = ""
    @State private var inviteCode: String = ""
    
    @State private var showInviteCodeCompletion: Bool = false
    @State private var showInviteCodeValidation: Bool = false
        
    var body: some View {
        Group {
            if isExpanded {
                Group {
                    switch negguState {
                    case .main:
                        VStack(alignment: .leading, spacing: 20) {
                            Button {
                                negguState = .generateInvite
                            } label: {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 12) {
                                        GradientView {
                                            Image(.negguStar)
                                        }
                                        
                                        GradientView {
                                            Text("네가 좀 꾸며줘!")
                                                .negguFont(.body1b)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(.chevronRight)
                                            .frame(width: 32, height: 32)
                                    }
                                    
                                    Text("친구가 내 옷장 속 옷들로 꾸밀 수 있도록 초대코드를 생성해요!")
                                        .negguFont(.body3)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            GnbOpendedViewItem("초대코드로 꾸며주기", leftIcon: .number, rightIcon: .chevronRight) {
                                negguState = .acceptInvite
                            }
                            .frame(height: 32)
                        }
                        .negguFont(.body1b)
                    case .generateInvite:
                        VStack(spacing: 20) {
                            HStack(spacing: 12) {
                                GradientView {
                                    Image(.negguStar)
                                }
                                
                                GradientView {
                                    Text("네가 좀 꾸며줘!")
                                        .negguFont(.body1b)
                                }
                                
                                Spacer()
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
                                        
                                        Text(generatedInviteCode)
                                        
                                        Spacer()
                                        
                                        Button {
                                            UIPasteboard.general.string = generatedInviteCode
                                            showInviteCodeCompletion = true
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
                        }
                        .overlay {
                            if showInviteCodeCompletion {
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
                                }
                                .onAppear {
                                    Task {
                                        try await Task.sleep(for: .seconds(1))
                                        showInviteCodeCompletion = false
                                    }
                                }
                            }
                        }
                        .animation(.easeInOut, value: showInviteCodeCompletion)
                        .onAppear {
                            lookBookViewModel.send(action: .generateNeggu(completion: { result in
                                generatedInviteCode = result.id
                            }))
                        }
                    case .acceptInvite:
                        VStack(alignment: .leading, spacing: 20) {
                            GnbOpendedViewItem("초대코드로 꾸며주기", leftIcon: .number)
                                .negguFont(.body1b)
                            
                            Text("친구가 공유해준 초대코드를 입력하면\n대신 꾸며 줄 수 있어요!")
                                .negguFont(.body3)
                            
                            HStack(spacing: 16) {
                                TextField(
                                    "",
                                    text: $inviteCode,
                                    prompt: Text("초대코드 입력").foregroundStyle(.labelInactive)
                                )
                                .negguFont(.body2)
                                .foregroundStyle(.labelNormal)
                                .keyboardType(.numberPad)
                                .onReceive(Just(inviteCode)) { newValue in
                                    let filteredString = newValue.filter { "0123456789".contains($0) }
                                    inviteCode = String(filteredString.prefix(6))
                                }
                                
                                Button {
                                    closetViewModel.checkInviteCode(inviteCode) { isValid in
                                        if isValid {
                                            coordinator.fullScreenCover = .lookbookRegister(inviteCode: inviteCode)
                                            isExpanded = false
                                        } else {
                                            showInviteCodeValidation = true
                                        }
                                    }
                                } label: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(inviteCode.count == 6 ? .negguSecondary : .bgInactive)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(.arrowRight)
                                                .foregroundStyle(inviteCode.count == 6 ? .white : .labelInactive)
                                        }
                                }
                                .disabled(inviteCode.count != 6)
                            }
                            .padding(.leading, 8)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.white)
                                    .strokeBorder(.lineAlt)
                            }
                            
                            if showInviteCodeValidation {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.warningAlt)
                                    .frame(height: 32)
                                    .overlay {
                                        HStack {
                                            Image(.xSmall)
                                            
                                            Text("존재하지 않거나 만료된 코드에요")
                                                .negguFont(.body3b)
                                                .lineLimit(1)
                                        }
                                        .foregroundStyle(.warning)
                                    }
                            }
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 28)
            } else {
                HStack(spacing: 10) {
                    GradientView {
                        Image(.negguStar)
                    }
                    
                    GradientView {
                        Text("네가 좀 꾸며줘!")
                            .negguFont(.body2b)
                    }
                }
                .padding(.horizontal)
                .onTapGesture {
                    isExpanded = true
                }
            }
        }
        .frame(
            width: isExpanded ? 328 : nil,
            height: isExpanded ? nil : 44
        )
        .background {
            RoundedRectangle(cornerRadius: isExpanded ? 20 : 100)
                .fill(.negguPrimary)
                .padding(isExpanded ? 2 : 0)
                .background {
                    if isExpanded {
                        Image(.gnbOpen)
                            .resizable()
                    }
                }
        }
        .clipShape(.rect(cornerRadius: isExpanded ? 20 : 100))
        .shadow(
            color: .black.opacity(0.05),
            radius: 4,
            x: 4, y: 4
        )
        .shadow(
            color: .black.opacity(0.1),
            radius: 10,
            y: 4
        )
        .onChange(of: isExpanded) { _, newValue in
            if newValue { return }
            negguState = .main
            inviteCode = ""
        }
        .onChange(of: coordinator.isGnbOpened) { _, newValue in
            if !newValue { return }
            isExpanded = false
        }
    }
    
    enum NegguState {
        case main
        case generateInvite
        case acceptInvite
    }
}
