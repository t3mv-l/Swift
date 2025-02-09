//
//  ViewController.swift//  krestiki_noliki
//
//  Created by Артём on 01.02.2025.
//

import UIKit

class ViewController: UIViewController {
    var counter = 0
    var gameState = ["", "", "", "", "", "", "", "", ""]
    var isGameActive = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        guard isGameActive else { return }
        
        counter += 1
        let player = counter % 2 == 1 ? "❌" : "⭕️"
        sender.setTitle(player, for: .normal)
        
        gameState[sender.tag] = player
        
        sender.isEnabled = false
        
        if checkForWinner() {
            showWinnerAlert(player: player)
            isGameActive = false
        } else if counter == 9 {
            showDrawAlert()
            isGameActive = false
        }
    }
    
    func checkForWinner() -> Bool {
        print("Current game state: \(gameState)")
        let winningCombinations = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        for combination in winningCombinations {
            let index0 = combination[0]
            let index1 = combination[1]
            let index2 = combination[2]
            
            if gameState[index0] == gameState[index1],
               gameState[index1] == gameState[index2],
               gameState[index0] != "" {
                print("Winner: \(gameState[index0])")
                return true
            }
        }
        
        return false
    }
    
    func showWinnerAlert(player: String) {
        let alert = UIAlertController(title: "Победа", message: "\(player) победил!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in self.resetGame()})
        present(alert, animated: true, completion: nil)
    }
    
    func showDrawAlert() {
        let alert = UIAlertController(title: "Ничья", message: "Игра закончилась вничью!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) {_ in self.resetGame()})
        present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        counter = 0
        isGameActive = true
        gameState = ["", "", "", "", "", "", "", "", ""]
            
        for subview in view.subviews {
            if let button = subview as? UIButton {
                button.setTitle("", for: .normal)
                button.isEnabled = true
            }
        }
    }
}
