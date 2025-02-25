//
//  TextFieldDelegateExtension.swift
//  Test_cases
//
//  Created by Артём on 24.02.2025.
//

import UIKit

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard !model.gameOverStatus else { return true }
        
        if let inputText = textFieldForAnswer.text, !inputText.isEmpty {
            if inputText.lowercased() == "Kylian Mbappe".lowercased() || inputText.lowercased() == "Mbappe".lowercased() {
                gameOver(isWin: true)
            } else {
                model.guessesLeft -= 1
                textFieldForQuestions.isHidden = true
                guessesLeftLabel.isHidden = false
                guessesLeftLabel.textColor = .white
                guessesLeftLabel.font = .systemFont(ofSize: 17)
                guessesLeftLabel.textAlignment = .center
                guessesLeftLabel.text = "Wrong guess! You have \(model.guessesLeft) tries left."
                if !ballImages.isEmpty {
                    ballImages.remove(at: 0).removeFromSuperview()
                }
                if model.guessesLeft == 0 {
                    guessesLeftLabel.isHidden = true
                    gameOver(isWin: false)
                }
                textFieldForAnswer.text = ""
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
