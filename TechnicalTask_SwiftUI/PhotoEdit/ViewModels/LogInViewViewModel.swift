//
//  LogInViewViewModel.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import FirebaseAuth
import SwiftUI
import GoogleSignIn
import FirebaseCore

class LogInViewViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(){}
    
    func login() {
        guard validate() else { return }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if error != nil {
                    self?.alertMessage = "Invalid login or password"
                    self?.showAlert = true
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                    }
                }
            }
            
        }
    }
    
    private func validate() -> Bool {
        error = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Please fill in all the fields!"
            return false
        }
        
        guard email.contains("@") && email.contains(".") else {
            error = "Please enter a valid e-mail address!"
            return false
        }
        
        return true
    }
        
    func handleSignInButton() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let user = signInResult?.user, let idToken = user.idToken else { return }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let user = data?.user else { return }
                print(user)
            }
        }
    }
}
