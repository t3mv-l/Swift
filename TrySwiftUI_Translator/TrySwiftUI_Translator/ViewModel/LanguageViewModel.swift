//
//  LanguageViewModel.swift
//  TrySwiftUI_Translator
//
//  Created by Артём on 08.04.2025.
//

import Foundation

class LanguageViewModel: ObservableObject {
    @Published var currentInputLang: LanguageModel = .English
    @Published var currentOutputLang: LanguageModel = .Yoda
    @Published var inputText: String = ""
    @Published var outputText: String = ""
    
    func translate() {
        let urlString = "https://api.funtranslations.com/translate/\(currentOutputLang.rawValue.lowercased()).json?text=\(inputText)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let jsonResponse = try?
                JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let contents = jsonResponse["contents"] as? [String: Any],
                let translatedText = contents["translated"] as? String {
                DispatchQueue.main.async {
                    self.outputText = translatedText
                }
            }
        }.resume()
    }
}
