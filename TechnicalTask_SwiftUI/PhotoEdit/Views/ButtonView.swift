//
//  ButtonView.swift
//  PhotoEditor
//
//  Created by Артём on 01.05.2025.
//

import SwiftUI

struct ButtonView<ViewModel: ObservableObject>: View {
    @ObservedObject var viewModel: ViewModel
    var title: String
    var buttonColor: Color
    var action: () -> Void
    
    private var isButtonDisabled: Bool {
        if let loginViewModel = viewModel as? LogInViewViewModel {
            return loginViewModel.email.isEmpty || loginViewModel.password.isEmpty
        } else if let registerViewModel = viewModel as? RegistrationViewViewModel {
            return registerViewModel.email.isEmpty || registerViewModel.password.isEmpty
        } else if let restorePasswordViewModel = viewModel as? RestorePasswordViewViewModel {
            return restorePasswordViewModel.email.isEmpty
        }
        return false
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
        }
        .frame(width: 360, height: 50)
        .background(isButtonDisabled ? .gray : buttonColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .disabled(isButtonDisabled)
    }
}

#Preview {
    @ObservedObject var viewModel = LogInViewViewModel()
    ButtonView(viewModel: viewModel, title: "Sign In", buttonColor: .blue) {
        viewModel.login()
    }
}
