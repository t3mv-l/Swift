//
//  AvailableLanguagesView.swift
//  TrySwiftUI_Translator
//
//  Created by Артём on 08.04.2025.
//

import SwiftUI

struct AvailableLanguagesView: View {
    @Binding var selectedLanguage: LanguageModel
    var body: some View {
        List(LanguageModel.allCases, id: \.self) { language in
            HStack {
                Text(String(describing: language))
                Spacer()
                if language == selectedLanguage {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedLanguage = language
            }
        }
    }
}
