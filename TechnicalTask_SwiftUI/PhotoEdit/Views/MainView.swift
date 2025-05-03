//
//  MainView.swift
//  PhotoEditor
//
//  Created by Артём on 30.04.2025.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    var body: some View {
        VStack {
            if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
                PhotoEditorView()
            } else {
                LogInView()
            }
        }
        .padding()
    }
}

#Preview {
    MainView()
}
