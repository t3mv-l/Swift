//
//  ChooseLangView.swift
//  TrySwiftUI_Translator
//
//  Created by Артём on 08.04.2025.
//

import SwiftUI

struct ChooseLangView: View {
    @StateObject private var viewModel = LanguageViewModel()
    @State private var isShowingInputLanguagePicker = false
    @State private var isShowingOutputLanguagePicker = false
    var body: some View {
        VStack {
            HStack {
                Button(String(describing: viewModel.currentInputLang)) {
                    isShowingInputLanguagePicker = true
                }
                .sheet(isPresented: $isShowingInputLanguagePicker) {
                    AvailableLanguagesView(selectedLanguage: $viewModel.currentInputLang)
                }
                .padding()
                Button("", systemImage: "arrow.left.arrow.right") {
                    let temp = viewModel.currentInputLang
                    viewModel.currentInputLang = viewModel.currentOutputLang
                    viewModel.currentOutputLang = temp
                }
                .padding()
                Button(String(describing: viewModel.currentOutputLang)) {
                    isShowingOutputLanguagePicker = true
                }
                .sheet(isPresented: $isShowingOutputLanguagePicker) {
                    AvailableLanguagesView(selectedLanguage: $viewModel.currentOutputLang)
                }
                .padding()
            }
            Form {
                TextEditor(text: $viewModel.inputText)
                    .foregroundStyle(.foreground)
                    .frame(height: 240)
                    .onChange(of: viewModel.inputText) {
                        viewModel.translate()
                    }
            }
            if !viewModel.inputText.isEmpty {
                Form {
                    TextEditor(text: $viewModel.outputText)
                        .foregroundStyle(.foreground)
                        .frame(height: 240)
                }
            }
        }
    }
}

#Preview {
    ChooseLangView()
}
