//
//  NegguAlert.swift
//  neggu
//
//  Created by 유지호 on 11/19/24.
//

import SwiftUI

struct NegguAlert: ViewModifier {
    @Binding var showAlert: Bool
    
    let alertType: AlertType
    let leftAction: (() -> Void)?
    let rightAction: () -> Void
    
    init(
        _ alertType: AlertType,
        showAlert: Binding<Bool>,
        leftAction: (() -> Void)? = nil,
        rightAction: @escaping () -> Void
    ) {
        self.alertType = alertType
        self._showAlert = showAlert
        self.leftAction = leftAction
        self.rightAction = rightAction
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if showAlert {
                    Color.bgDimmed
                        .ignoresSafeArea()
                        .onTapGesture {
                            showAlert = false
                        }
                    
                    VStack(spacing: 24) {
                        Text(alertType.title)
                            .negguFont(.title4)
                            .foregroundStyle(.labelNormal)
                        
                        if !alertType.description.isEmpty {
                            Text(alertType.description)
                                .negguFont(.body2)
                                .foregroundStyle(.labelAlt)
                                .multilineTextAlignment(.center)
                        }
                        
                        HStack(spacing: 12) {
                            Button {
                                if let leftAction {
                                    leftAction()
                                } else {
                                    showAlert = false
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.clear)
                                    .frame(height: 48)
                                    .overlay {
                                        Text(alertType.leftContent)
                                            .negguFont(.body2)
                                            .foregroundStyle(.labelInactive)
                                    }
                            }
                            
                            Button {
                                rightAction()
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(alertType.buttonColor)
                                    .frame(height: 48)
                                    .overlay {
                                        Text(alertType.rightContent)
                                            .negguFont(.body2b)
                                            .foregroundStyle(.labelRNormal)
                                    }
                            }
                        }
                        .frame(height: 52)
                    }
                    .padding([.horizontal, .bottom], 20)
                    .padding(.top, 40)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                    }
                    .padding(.horizontal, 32)
                }
            }
            .animation(.smooth(duration: 0.3), value: showAlert)
    }
}

extension View {
    
    func negguAlert(
        _ alertType: AlertType,
        showAlert: Binding<Bool>,
        leftAction: @escaping () -> Void,
        rightAction: @escaping () -> Void
    ) -> some View {
        modifier(
            NegguAlert(
                alertType,
                showAlert: showAlert,
                leftAction: leftAction,
                rightAction: rightAction
            )
        )
    }
    
    func negguAlert(
        _ alertType: AlertType,
        showAlert: Binding<Bool>,
        rightAction: @escaping () -> Void
    ) -> some View {
        modifier(
            NegguAlert(
                alertType,
                showAlert: showAlert,
                rightAction: rightAction
            )
        )
    }
    
}

enum AlertType {
    case needClothes
    case cancelRegister(Entry)
    case delete(Entry)
    case logout
    case withdraw
    
    enum Entry {
        case clothes
        case lookBook
    }
    
    var title: String {
        switch self {
        case .needClothes: "등록된 의상이 없습니다"
        case .cancelRegister(let entry):
            switch entry {
            case .clothes: "의상 등록을 그만둘까요?"
            case .lookBook: "룩북 등록을 그만둘까요?"
            }
        case .delete(let entry):
            switch entry {
            case .clothes: "의상을 삭제할까요?"
            case .lookBook: "룩북을 삭제할까요?"
            }
        case .logout:
            if let nickname = UserDefaultsKey.User.nickname {
                nickname + "님"
            } else {
                ""
            }
        case .withdraw: "탈퇴하시겠습니까?"
        }
    }
    
    var description: String {
        switch self {
        case .needClothes: "룩북을 만들기 위해 의상을 등록해주세요"
        case .cancelRegister: "지금까지 편집한 내용은 저장되지 않습니다"
        case .delete(let entry):
            switch entry {
            case .clothes: "삭제한 의상은 복구할 수 없습니다"
            case .lookBook: "삭제한 룩북은 복구할 수 없습니다"
            }
        case .logout: "로그아웃하시겠습니까?"
        case .withdraw: "모든 정보는 즉시 삭제되며, 탈퇴 이후에는 복구할 수 없습니다"
        }
    }
    
    var leftContent: String {
        switch self {
        case .needClothes: "닫기"
        case .cancelRegister: "이어서 편집하기"
        case .delete, .logout, .withdraw: "취소하기"
        }
    }
    
    var rightContent: String {
        switch self {
        case .needClothes: "의상 등록하기"
        case .cancelRegister: "그만하기"
        case .delete: "삭제하기"
        case .logout: "로그아웃하기"
        case .withdraw: "탈퇴하기"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .needClothes: .black
        default: .warning
        }
    }
}

