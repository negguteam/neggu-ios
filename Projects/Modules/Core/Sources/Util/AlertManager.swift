//
//  AlertManager.swift
//  neggu
//
//  Created by 유지호 on 5/2/25.
//

import SwiftUI

public final class AlertManager: ObservableObject {
    
    @Published var showAlert: Bool = false
    @Published private(set) var title: String = "안내"
    @Published private(set) var message: String = "알 수 없는 에러가 발생했습니다."
    @Published private(set) var action: (() -> Void)?
    
    public static let shared = AlertManager()
    
    private init() { }
    
    public func setAlert(
        title: String = "안내",
        message: String = "알 수 없는 에러가 발생했습니다.",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
        self.showAlert = true
    }
    
    public func resetAlert() {
        self.showAlert = false
        self.title = "안내"
        self.message = "알 수 없는 에러가 발생했습니다."
        self.action = nil
    }
    
}


public struct AlertView: View {
    @StateObject private var alertManager = AlertManager.shared
    
    public init() { }
    
    public var body: some View {
        Color.clear
            .alert(
                alertManager.title,
                isPresented: $alertManager.showAlert
            ) {
                Button("확인") {
                    alertManager.action?()
                    alertManager.resetAlert()
                }
            } message: {
                Text(alertManager.message)
            }
            .tint(.orange)
    }
}
