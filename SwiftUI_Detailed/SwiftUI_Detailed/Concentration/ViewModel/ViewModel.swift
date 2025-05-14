//
//  ViewModel.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 08.05.2025.
//

import SwiftUI

class GameViewModel: ObservableObject {
    typealias Card = GameModel<String>.Card
    private static let emojis = ["🍀", "👻", "😎", "🏆", "🙈", "👀", "🏆", "👻", "👀", "❤️", "🙈", "😇", "🍀", "😎", "😇", "❤️"]
    
    private static func createGame() -> GameModel<String> {
        return GameModel(numberOfPairsOfCards: 8) { index in
            if emojis.indices.contains(index) {
                return emojis[index]
            } else {
                return "⁉️"
            }
        }
    }
        
    @Published private var model = createGame()
    let alertTitle = "Congratulations, you won!"
    let alertMessage = "Your final score is "
        
    var cards: Array<Card> {
        model.cards
    }
    
    var color: Color {
        .orange
    }
    
    var score: Int {
        model.score
    }
    
    var isGameFinished: Bool {
        model.isGameFinished
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func resetGame() {
        model = GameViewModel.createGame()
    }
}
