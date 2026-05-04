//
//  ContentViewModel.swift
//  TrySwiftUI_FaceID
//
//  Created by Артём on 10.04.2026.
//

import Foundation
import Combine
import LocalAuthentication

enum PasscodeMode {
    case register, confirm, unlock
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var digits: [String] = []
    @Published var mode: PasscodeMode = .register
    @Published var errorMessage: String = ""
    @Published var isUnlocked: Bool = false
    @Published var headerTitle: String = ""
    @Published var headerSubtitle: String = ""
    @Published var showSuccess: Bool = false
    
    private var pendingPasscode: String = ""
    private let codeLength: Int = 4
    
    init() {
        setupMode()
        if mode == .unlock {
            authWithFaceID()
        }
    }
    
    private func setupMode() {
        if KeychainManager.shared.hasPasscode() {
            mode = .unlock
            headerTitle = "Добро Пожаловать"
            headerSubtitle = "Введите пароль"
        } else {
            mode = .register
            headerTitle = "Создайте пароль"
            headerSubtitle = "Придумайте четырёхзначный код"
        }
    }
    
    func appendDigit(_ digit: String) {
        guard digits.count < codeLength else { return }
        digits.append(digit)
        if digits.count == codeLength {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.processCode()
            }
        }
    }
    
    func deleteLastDigit() {
        guard !digits.isEmpty else { return }
        digits.removeLast()
        errorMessage = ""
    }
    
    private func processCode() {
        let code = digits.joined()
        switch mode {
        case .register:
            pendingPasscode = code
            digits = []
            mode = .confirm
            headerTitle = "Подтвердите пароль"
            headerSubtitle = "Повторите введённый код"
            errorMessage = ""
        case .confirm:
            if code == pendingPasscode {
                _ = KeychainManager.shared.savePasscode(code)
                showSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.isUnlocked = true
                }
            } else {
                triggerError("Пароли не совпадают. Попробуйте ещё раз")
                pendingPasscode = ""
                mode = .register
                headerTitle = "Создайте пароль"
                headerSubtitle = "Придумайте четырёхзначный код"
            }
        case .unlock:
            if code == KeychainManager.shared.getPasscode() {
                showSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.isUnlocked = true
                }
            }
        }
    }
    
    private func triggerError(_ message: String) {
        digits = []
        errorMessage = message
    }
    
    func authWithFaceID() {
        let context = LAContext()
        var biometricError: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &biometricError) else {
            print("Биометрия недоступна")
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Войдите с помощью Face ID") { success, _ in
            DispatchQueue.main.async {
                if success {
                    self.showSuccess = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.isUnlocked = true
                    }
                } 
            }
        }
    }
}
