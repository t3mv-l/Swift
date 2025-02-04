//
//  main.swift
//  test_console_app
//
//  Created by Артём on 20.01.2025.
//

import Foundation

let rightAnswer = "Bruno Fernandes"

let clubsByLeague: [String: [String]] = [
    "EPL": ["Arsenal", "Chelsea", "Liverpool", "Manchester City", "Manchester United"],
    "Bundesliga": ["Bayern Munich", "Bayer Leverkusen", "Borussia Dortmund", "RB Leipzig"],
    "Serie A": ["Internazionale", "Milan", "Juventus", "Napoli", "Atalanta", "Lazio", "Roma"],
    "LaLiga": ["Barcelona", "Real Madrid", "Atletico Madrid"],
    "Ligue 1": ["PSG", "Monaco", "Olympique Lyonnais", "Marseille"],
    "Eredivisie": ["Ajax", "PSV", "Feyenoord"],
    "Liga Portugal": ["Benfica", "Porto", "Sporting"],
    "Turkish Superleague": ["Galatasaray", "Fenerbahce", "Besiktas"]
]

let positions = ["Goalkeeper", "Defender", "Midfielder", "Forward"]
let nationalities = ["Argentina", "Brazil", "France", "Germany", "Italy", "Spain", "England", "Portugal", "Netherlands", "Uruguay"]

var attempts = 3
var questions = 10

func promptUser(for options: [String], message: String) -> String? {
    print(message)
    for option in options {
        print(option)
    }
    return readLine()
}

func guess(for options: [String], correctAnswer: String, message: String) {
    if let userInput = promptUser(for: options, message: message) {
        if userInput.lowercased() == correctAnswer.lowercased() || userInput == correctAnswer {
            print("You're right!\n")
        } else {
            print("You're wrong. Try again\n")
        }
    }
}

func guessLeague() {
    let leagueOptions = Array(clubsByLeague.keys)
    if let userInput = promptUser(for: leagueOptions, message: "\nChoose a league:") {
        if let selectedClubs = clubsByLeague[userInput] {
            let correctIndex = min(4, selectedClubs.count - 1)
            guess(for: selectedClubs, correctAnswer: selectedClubs[correctIndex], message: "\nChoose a club:")
        } else {
            print("Invalid league")
        }
    }
}

func noMoreQuestions() {
    if let guessInput = promptUser(for: [], message: "\nWhat is your guess?") {
        if guessInput == rightAnswer {
            print("\nCongratulations, you won! This is Bruno Fernandes indeed")
            exit(0)
        } else if guessInput != rightAnswer && attempts == 1 {
            attempts -= 1
            gameOver()
        } else {
            print("\nYou're wrong. Try again")
            attempts -= 1
        }
    }
}

func gameOver() {
    if attempts == 0 {
        print("You lost. This is Bruno Fernandes")
        return
    }
}

func startGame() {
    print("The game has started. ")
    while attempts > 0 {
        print("You have \(attempts) attempts to guess the football player. You can also ask \(questions) questions about him.\n")
        
        if questions > 0 {
            let userInput = promptUser(for: ["League", "Position", "Nationality", "Guess The Player\n"], message: "What do you want to guess?\n")
            
            switch userInput {
            case "League":
                questions -= 1
                guessLeague()
            case "Position":
                questions -= 1
                guess(for: positions, correctAnswer: positions[2], message: "\nChoose a position:")
            case "Nationality":
                questions -= 1
                guess(for: nationalities, correctAnswer: nationalities[7], message: "\nChoose a nationality:")
            case "Guess The Player":
                noMoreQuestions()
            default:
                print("Unknown input")
            }
        } else {
            noMoreQuestions()
        }
    }
}

func main() {
    startGame()
}

main()
