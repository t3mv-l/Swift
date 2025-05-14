//
//  TicTacToeView.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 11.05.2025.
//

import SwiftUI

struct TicTacToeView: View {
    @ObservedObject var vm: TicTacToeViewModel
    
    var body: some View {
        VStack {
            GridView(vm: vm) { index in
                vm.makeMove(at: index)
            }
            Button("Restart the game") {
                vm.resetGame()
            }
            .padding()
            .foregroundColor(.blue)
        }
        .alert(vm.alertTitle, isPresented: $vm.showAlert) {
            Button("OK") {
                vm.resetGame()
            }
        } message: {
            if let winner = vm.winner {
                Text("\(winner) won!")
            } else if !vm.isGameActive && vm.counter == 9 {
                Text(vm.alertDrawMessage)
            }
        }
    }
}

struct GridView: View {
    @ObservedObject var vm: TicTacToeViewModel
    var onMove: (Int) -> Void
    let frameSize: CGFloat = 80
    let fontSize: CGFloat = 60
    let opacity: Double = 0.5

    
    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { column in
                        let index = row * 3 + column
                        Button {
                            onMove(index)
                        } label: {
                            Text(vm.gameState[index])
                                .font(.system(size: fontSize))
                                .frame(width: frameSize, height: frameSize)
                                .background(Color.mint.opacity(opacity))
                                .clipShape(Circle())
                        }
                        .disabled(!vm.isGameActive || vm.gameState[index] != "")
                    }
                }
            }
        }
    }
}

#Preview {
    TicTacToeView(vm: TicTacToeViewModel())
}
