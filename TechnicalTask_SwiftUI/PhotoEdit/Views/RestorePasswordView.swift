//
//  RestorePasswordView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI

struct RestorePasswordView: View {
    @StateObject var viewModel = RestorePasswordViewViewModel()
    
    var body: some View {
        VStack {
            Text("Restore password")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Enter the e-mail address you used to register")
                .padding()
            
            TextField("E-mail address", text: $viewModel.email)
                .customTextFieldStyle()
            
            ButtonView(viewModel: viewModel, title: "Restore password", buttonColor: .pink) {
                viewModel.restore()
            }
                        
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Attention"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    RestorePasswordView()
}
