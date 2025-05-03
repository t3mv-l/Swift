//
//  RestorePasswordViewViewModel.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RestorePasswordViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {}
    
    func restore() {
        guard validate() else { return }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "The letter with instructions has been sent to \(self.email)"
            }
            self.showAlert = true
        }
    }
    
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
                
        guard email.contains("@") && email.contains(".") else {
            return false
        }
                
        return true
    }
}
