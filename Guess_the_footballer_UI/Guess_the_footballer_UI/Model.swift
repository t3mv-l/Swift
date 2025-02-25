//
//  Model.swift
//  Test_cases
//
//  Created by Артём on 24.02.2025.
//

class GameModel {
    var gameOverStatus = false
            
    var selectedPosition: String?
    var isTableViewVisible = false
    
    enum SelectedCategory {
        case club
        case league
        case country
        case position
    }
    
    var selectedCategory: SelectedCategory = .country
    
    var clubImageViews: [String] = ["Flag_of_England.svg", "Flag_of_England.svg", "Flag_of_England.svg", "Flag_of_England.svg", "Flag_of_England.svg", "Flag_of_England.svg", "Flag_of_Germany", "Flag_of_Germany", "Flag_of_Germany", "Flag_of_Germany", "Flag_of_Spain.svg", "Flag_of_Spain.svg", "Flag_of_Spain.svg", "Flag_of_Italy.svg", "Flag_of_Italy.svg", "Flag_of_Italy.svg", "Flag_of_Italy.svg", "Flag_of_France.svg", "Flag_of_France.svg", "Flag_of_France.svg", "Flag_of_Portugal", "Flag_of_Portugal", "Flag_of_Portugal", "Flag_of_Netherlands.svg", "Flag_of_Netherlands.svg", "Flag_of_Netherlands.svg", "Flag_of_Turkey.svg", "Flag_of_Turkey.svg", "Flag_of_Turkey.svg"]
    var clubStringValues: [String] = ["Arsenal", "Chelsea", "Liverpool", "Manchester City", "Manchester United", "Tottenham", "Bayern Munich", "Bayer Leverkusen", "Borussia Dortmund", "RB Leipzig", "Atletico Madrid", "Barcelona", "Real Madrid", "Internazionale", "Juventus", "Milan", "Napoli", "Marseille", "Monaco", "PSG", "Benfica", "Porto", "Sporting", "Ajax", "Feyenoord", "PSV", "Besiktas", "Fenerbahce", "Galatasaray"]
    
    var leagueImageViews: [String] = ["Flag_of_England.svg", "Flag_of_Germany", "Flag_of_Spain.svg", "Flag_of_Italy.svg", "Flag_of_France.svg", "Flag_of_Portugal", "Flag_of_Netherlands.svg", "Flag_of_Turkey.svg"]
    var leagueStringValues: [String] = ["Premier League", "Bundesliga", "LaLiga", "Serie A", "Ligue 1", "Liga Portugal", "Eredivisie", "Superliga"]
    
    var countryImageViews: [String] = ["Flag_of_Argentina.svg", "Flag_of_Brazil.svg", "Flag_of_England.svg", "Flag_of_France.svg", "Flag_of_Germany", "Flag_of_Italy.svg", "Flag_of_Netherlands.svg", "Flag_of_Portugal", "Flag_of_Spain.svg", "Flag_of_Uruguay.svg"]
    var countryStringValues: [String] = ["Argentina", "Brazil", "England", "France", "Germany", "Italy", "Netherlands", "Portugal", "Spain", "Uruguay"]
    
    let positionMap: [String: String] = [
        "GK": "goalkeeper",
        "DF": "defender",
        "MF": "midfielder",
        "FW": "forward"
    ]
            
    var guess: [String] = ["Yes", "No"]
    
    var attemptsLeftDefault = 10
    var guessesLeft = 3
    
    var userSelections: [String] = []
    var userAnswers: [String] = []
    let maxSelections = 10
}
