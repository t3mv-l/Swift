//
//  TicTacToeViewModel.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 14.05.2025.
//

import SwiftUI

class TicTacToeViewModel: ObservableObject {
    @Published private var model = TicTacToeModel()
    
    let alertTitle = "Game over"
    let alertDrawMessage = "It's a draw!"
    
    var counter: Int {
        model.counter
    }
    
    var gameState: [String] {
        model.gameState
    }
    
    var winner: String? {
        model.winner
    }
    
    var isGameActive: Bool {
        model.isGameActive
    }
    
    var showAlert: Bool {
        get {
            model.showAlert
        }
        set {
            model.showAlert = newValue
        }
    }
    
    func makeMove(at index: Int) {
        model.makeMove(at: index)
    }
    
    func checkForWinner() -> Bool {
        model.checkForWinner()
    }
    
    func resetGame() {
        model.resetGame()
    }
}
