//
//  TicTacToeModel.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 14.05.2025.
//

import Foundation

struct TicTacToeModel {
    private(set) var counter = 0
    private(set) var gameState = Array(repeating: "", count: 9)
    var isGameActive = true
    var showAlert = false
    private(set) var winner: String? = nil
    
    mutating func makeMove(at index: Int) {
        guard isGameActive else { return }
        counter += 1
        let player = counter % 2 == 0 ? "❌" : "⭕️"
        gameState[index] = player
        
        if checkForWinner() {
            winner = player
            isGameActive = false
            showAlert = true
        } else if counter == 9 {
            isGameActive = false
            showAlert = true
        }
    }
    
    func checkForWinner() -> Bool {
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
            
            if gameState[index0] == gameState[index1], gameState[index1] == gameState[index2], gameState[index0] != "" {
                return true
            }
        }
        
        return false
    }
    
    mutating func resetGame() {
        counter = 0
        isGameActive = true
        gameState = Array(repeating: "", count: 9)
        winner = nil
        showAlert = false
    }
}
