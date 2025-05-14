//
//  SwiftUI_DetailedApp.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 07.05.2025.
//

import SwiftUI

@main
struct SwiftUI_DetailedApp: App {
    @StateObject var game = GameViewModel()
    @StateObject var tttgame = TicTacToeViewModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("TicTacToe", systemImage: "xmark.circle") {
                    TicTacToeView(vm: tttgame)
                }
                Tab("Concentration", systemImage: "square.grid.4x3.fill") {
                    GameView(vm: game)
                }
            }
        }
    }
}
