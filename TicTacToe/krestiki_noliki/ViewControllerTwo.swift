//
//  ViewControllerTwo.swift
//  krestiki_noliki
//
//  Created by Артём on 08.02.2025.
//

import UIKit

class ViewControllerTwo: UIViewController {
    var emojis = ["🍀", "👻", "😎", "🏆", "🙈", "👀", "🏆", "👻", "👀", "❤️", "🙈", "😇", "🍀", "😎", "😇", "❤️"]
    var shuffledEmojis: [String] = []
    var firstCardIndex: Int?
    var secondCardIndex: Int?
    var isGameActive = true
    var openedCardsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    func initializeGame() {
        shuffledEmojis = emojis.shuffled()
        fillButtonsWithRandomEmojis()
        openedCardsCount = 0
    }

    @IBAction func buttonClickAppTwo(_ sender: UIButton) {
        guard isGameActive else { return }
        
        let buttonIndex = sender.tag - 1
        
        if sender.title(for: .normal) == "" {
            UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                sender.setTitle(self.shuffledEmojis[buttonIndex], for: .normal)
            }) { _ in
                if self.firstCardIndex == nil {
                    self.firstCardIndex = buttonIndex
                } else {
                    self.secondCardIndex = buttonIndex
                    self.checkForMatch()
                }
            }
        }
    }

    func checkForMatch() {
        guard let firstIndex = firstCardIndex, let secondIndex = secondCardIndex else { return }

        if shuffledEmojis[firstIndex] == shuffledEmojis[secondIndex] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let button1 = self.view.viewWithTag(firstIndex + 1) as? UIButton,
                   let button2 = self.view.viewWithTag(secondIndex + 1) as? UIButton {
                    button1.isHidden = true
                    button2.isHidden = true
                }
                self.openedCardsCount += 2
                self.checkForVictory()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let button1 = self.view.viewWithTag(firstIndex + 1) as? UIButton,
                   let button2 = self.view.viewWithTag(secondIndex + 1) as? UIButton {
                    UIView.transition(with: button1, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        button1.setTitle("", for: .normal)
                    }, completion: nil)
                    UIView.transition(with: button2, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        button2.setTitle("", for: .normal)
                    }, completion: nil)
                }
            }
        }
        
        firstCardIndex = nil
        secondCardIndex = nil
    }

    func checkForVictory() {
        if openedCardsCount == shuffledEmojis.count {
            gameOverAlert()
            isGameActive = false
        }
    }

    func fillButtonsWithRandomEmojis() {
        for i in 1...16 {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.setTitle("", for: .normal)
                button.isEnabled = true
                button.isHidden = false
            }
        }
    }

    func gameOverAlert() {
        let alert = UIAlertController(title: "Игра окончена!", message: "Поздравляем, Вы победили!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.resetGame() })
        present(alert, animated: true, completion: nil)
    }

    func resetGame() {
        emojis = ["🍀", "👻", "😎", "🏆", "🙈", "👀", "🏆", "👻", "👀", "❤️", "🙈", "😇", "🍀", "😎", "😇", "❤️"]
        isGameActive = true
        firstCardIndex = nil
        secondCardIndex = nil
        initializeGame()
    }
}
