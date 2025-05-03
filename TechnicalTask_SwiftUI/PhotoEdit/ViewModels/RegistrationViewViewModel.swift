//
//  RegistrationViewViewModel.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class RegistrationViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {}
    
    func register() {
        guard validate() else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.alertMessage = error.localizedDescription
                self?.showAlert = true
                return
            }
            
            guard let userId = result?.user.uid else { return }
            self?.insertUser(id: userId)
            self?.sendEmailVerification()
        }
    }
    
    private func insertUser(id: String) {
        let newUser = User(id: id, email: email)
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
                
        guard email.contains("@") && email.contains(".") else {
            return false
        }
                
        guard password.count >= 6 else {
            return false
        }
        
        return true
    }
    
    private func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification() { error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "A confirmation letter has been sent to \(self.email)"
            }
            self.showAlert = true
        }
    }
}
