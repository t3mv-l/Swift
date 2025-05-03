//
//  RegistrationView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewViewModel()
    
    var body: some View {
        VStack {
            Text("Please fill in all the fields to register")
                .font(.title2)
                .bold()
                .padding(.top, 30)
            
            VStack(spacing: 15) {
                TextField("E-mail address", text: $viewModel.email)
                    .customTextFieldStyle()
                
                SecureField("Password", text: $viewModel.password)
                    .customTextFieldStyle()
            }
            
            ButtonView(viewModel: viewModel, title: "Register", buttonColor: .green) {
                viewModel.register()
            }
                        
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Attention"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    RegistrationView()
}
