//
//  AlertManager.swift
//  neggu
//
//  Created by 유지호 on 5/2/25.
//

import SwiftUI

final class AlertManager: ObservableObject {
    
    @Published var showAlert: Bool = false
    @Published private(set) var title: String = "안내"
    @Published private(set) var message: String = "알 수 없는 에러가 발생했습니다."
    @Published private(set) var action: (() -> Void)?
    
    static let shared = AlertManager()
    
    private init() { }
    
    func setAlert(
        title: String = "안내",
        message: String = "알 수 없는 에러가 발생했습니다.",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.action = action
        self.showAlert = true
    }
    
    func resetAlert() {
        self.showAlert = false
        self.title = "안내"
        self.message = "알 수 없는 에러가 발생했습니다."
        self.action = nil
    }
    
}


struct AlertView: View {
    @StateObject private var alertManager = AlertManager.shared
    
    var body: some View {
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
            .tint(.negguSecondary)
    }
}
