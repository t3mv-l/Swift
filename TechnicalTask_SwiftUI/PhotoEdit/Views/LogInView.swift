//
//  LogInView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import FirebaseAuth

struct LogInView: View {
    @StateObject var viewModel = LogInViewViewModel()
    //@State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                VStack(spacing: 15) {
                    if !viewModel.error.isEmpty {
                        Text(viewModel.error)
                            .foregroundStyle(Color.red)
                    }
                    TextField("E-mail address", text: $viewModel.email)
                        .customTextFieldStyle()
                    
                    SecureField("Password", text: $viewModel.password)
                        .customTextFieldStyle()
                }
                        
                ButtonView(viewModel: viewModel, title: "Sign In", buttonColor: .blue) {
                    viewModel.login()
                }
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }
                    
                GoogleSignInButton {
                    viewModel.handleSignInButton()
                }
                .frame(width: 360)
                                
                NavigationLink("Forgot the password?") {
                    RestorePasswordView()
                }
                .padding()
                .bold()
                .foregroundStyle(.blue)
                    
                NavigationLink("Create an account") {
                    RegistrationView()
                }
                .bold()
                .foregroundStyle(.blue)
                
                Spacer()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    LogInView()
}

struct LoginViewSameThings: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 360, height: 50)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .autocapitalization(.none)
            .autocorrectionDisabled()
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        return modifier(LoginViewSameThings())
    }
}
