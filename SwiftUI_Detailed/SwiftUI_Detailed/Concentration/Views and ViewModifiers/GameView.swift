//
//  GameView.swift
//  SwiftUI_Detailed
//
//  Created by Артём on 07.05.2025.
//

import SwiftUI

struct GameView: View {
    typealias Card = GameModel<String>.Card
    @ObservedObject var vm: GameViewModel
    @State private var showAlert = false
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval: TimeInterval = 0.15
    private let deckWidth: CGFloat = 50
    
    var body: some View {
        VStack {
            cards.foregroundStyle(vm.color)
            HStack {
                score
                Spacer()
                deck.foregroundStyle(vm.color)
                Spacer()
                shuffle
            }
            .font(.largeTitle)
            .fontWeight(.semibold)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(vm.alertTitle), message: Text(vm.alertMessage + "\(vm.score)"), dismissButton: .default(Text("OK")){
                withAnimation {
                    vm.resetGame()
                }
            })
        }
        .onChange(of: vm.isGameFinished, { _, newValue in
            if newValue {
                showAlert = true
            }
        })
        .padding()
    }
    
    private var score: some View {
        Text("Score: \(vm.score)")
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                vm.shuffle()
            }
        }
    }
    
    private var cards: some View {
        AspectVGridView(vm.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(spacing)
                    .overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        choose(card)
                    }
                    .transition(.opacity)
            }
        }
    }
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        vm.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        for card in vm.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
    }
    
    private func choose(_ card: Card) {
        withAnimation {
            let scoreBeforeChoosing = vm.score
            vm.choose(card)
            let scoreChange = vm.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange: (amount: Int, causedByCardId: Card.ID) = (amount: 0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}

#Preview {
    GameView(vm: GameViewModel())
}
