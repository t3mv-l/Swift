//
//  ViewController.swift
//  Test_cases
//
//  Created by Артём on 10.02.2025.
//

import UIKit

class ViewController: UIViewController {
    let picture = UIImageView()
    var ballImages: [UIImageView] = []
    let rightAnswer = UIImageView()
    
    let border = UIView()
    var originalButtons: [UIButton] = []
    var extraButtons: [UIButton] = []
    var lastTappedButton: UIButton?
    
    let textFieldForQuestions = UITextField()
    let popUpTableView = UITableView()
    
    let userQuestionsTableView = UITableView()
    var guessLabel = UILabel()
        
    var guess: [String] = ["Yes", "No"]
    
    let textFieldForAnswer = UITextField()
    var giveUp = UIButton()
        
    var attemptsLeft = UILabel()
    var guessesLeftLabel = UILabel()
    
    let model = GameModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setLayoutAndConstraints()
    }
    
    func setLayoutAndConstraints() {
        textFieldForAnswer.delegate = self
        textFieldForAnswer.placeholder = "Type name and surname"
        textFieldForAnswer.borderStyle = .roundedRect
        textFieldForAnswer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textFieldForAnswer)
        
        textFieldForQuestions.delegate = self
        textFieldForQuestions.placeholder = "Choose"
        textFieldForQuestions.borderStyle = .roundedRect
        textFieldForQuestions.translatesAutoresizingMaskIntoConstraints = false
        textFieldForQuestions.isHidden = false
        view.addSubview(textFieldForQuestions)
        
        guessesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLeftLabel.isHidden = true
        view.addSubview(guessesLeftLabel)
                
        picture.image = UIImage(named: "default")
        picture.layer.borderColor = UIColor.blue.cgColor
        picture.layer.borderWidth = 2
        picture.layer.masksToBounds = true
        picture.contentMode = .scaleAspectFit
        picture.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picture)
        
        rightAnswer.image = UIImage(named: "mbappe")
        rightAnswer.contentMode = .scaleAspectFit
        rightAnswer.translatesAutoresizingMaskIntoConstraints = false
        rightAnswer.alpha = 0.0
        view.addSubview(rightAnswer)
        
        border.layer.borderColor = UIColor.blue.cgColor
        border.layer.borderWidth = 2
        border.layer.cornerRadius = 20
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        
        attemptsLeft.text = "You have \(model.attemptsLeftDefault) questions left:"
        attemptsLeft.textColor = .white
        attemptsLeft.font = UIFont.boldSystemFont(ofSize: 20)
        attemptsLeft.textAlignment = .center
        attemptsLeft.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(attemptsLeft)
        
        userQuestionsTableView.delegate = self
        userQuestionsTableView.dataSource = self
        userQuestionsTableView.backgroundColor = .black
        userQuestionsTableView.layer.borderColor = UIColor.yellow.cgColor
        userQuestionsTableView.layer.borderWidth = 2
        userQuestionsTableView.layer.cornerRadius = 13
        userQuestionsTableView.translatesAutoresizingMaskIntoConstraints = false
        userQuestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserQuestionsCell")
        view.addSubview(userQuestionsTableView)
        
        popUpTableView.delegate = self
        popUpTableView.dataSource = self
        popUpTableView.backgroundColor = .black
        popUpTableView.layer.borderColor = UIColor.yellow.cgColor
        popUpTableView.layer.borderWidth = 2
        popUpTableView.layer.cornerRadius = 13
        popUpTableView.translatesAutoresizingMaskIntoConstraints = false
        popUpTableView.isHidden = true
        popUpTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(popUpTableView)
        
        giveUp = UIButton(type: .system)
        giveUp.setImage(UIImage(systemName: "flag.fill"), for: .normal)
        giveUp.layer.borderColor = UIColor.yellow.cgColor
        giveUp.layer.borderWidth = 2
        giveUp.backgroundColor = .black
        giveUp.layer.cornerRadius = 10
        giveUp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(giveUp)
        
        for i in 0..<3 {
            let ballImage = UIImageView()
            ballImage.image = UIImage(named: "soccer_ball")
            ballImage.contentMode = .scaleAspectFit
            ballImage.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(ballImage)
            
            ballImages.append(ballImage)
            
            let leadingOffset:CGFloat = 100 + 25 * CGFloat(i)
            
            NSLayoutConstraint.activate([
                ballImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                ballImage.centerXAnchor.constraint(equalTo: picture.centerXAnchor, constant: leadingOffset),
                ballImage.widthAnchor.constraint(equalToConstant: 25),
                ballImage.heightAnchor.constraint(equalToConstant: 25)
            ])
        }
        
        NSLayoutConstraint.activate([
            textFieldForAnswer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            textFieldForAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldForAnswer.widthAnchor.constraint(equalToConstant: 240),
            textFieldForAnswer.heightAnchor.constraint(equalToConstant: 40),
                        
            picture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            picture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picture.widthAnchor.constraint(equalToConstant: 100),
            picture.heightAnchor.constraint(equalToConstant: 100),
            
            rightAnswer.topAnchor.constraint(equalTo: picture.topAnchor),
            rightAnswer.centerXAnchor.constraint(equalTo: picture.centerXAnchor),
            rightAnswer.widthAnchor.constraint(equalTo:  picture.widthAnchor),
            rightAnswer.heightAnchor.constraint(equalTo: picture.heightAnchor),
            
            border.centerYAnchor.constraint(equalTo: picture.bottomAnchor, constant: 80),
            border.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            border.widthAnchor.constraint(equalToConstant: 360),
            border.heightAnchor.constraint(equalToConstant: 140),
            
            attemptsLeft.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            attemptsLeft.centerYAnchor.constraint(equalTo: border.bottomAnchor, constant: 25),
            
            userQuestionsTableView.centerYAnchor.constraint(equalTo: attemptsLeft.bottomAnchor, constant: 195),
            userQuestionsTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userQuestionsTableView.widthAnchor.constraint(equalToConstant: 360),
            userQuestionsTableView.heightAnchor.constraint(equalToConstant: 380),
            
            popUpTableView.topAnchor.constraint(equalTo: textFieldForQuestions.bottomAnchor, constant: 8),
            popUpTableView.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 20),
            popUpTableView.trailingAnchor.constraint(equalTo: border.trailingAnchor, constant: -20),
            popUpTableView.heightAnchor.constraint(equalToConstant: 100),
            
            giveUp.topAnchor.constraint(equalTo: textFieldForAnswer.topAnchor, constant: -1),
            giveUp.leadingAnchor.constraint(equalTo: textFieldForAnswer.trailingAnchor, constant: 18),
            giveUp.widthAnchor.constraint(equalToConstant: 41),
            giveUp.heightAnchor.constraint(equalToConstant: 41)
        ])
        
        addButtonsToBorderView()
        
        giveUp.addTarget(self, action: #selector(gameOver), for: .touchUpInside)
    }
    
    func addButtonsToBorderView() {
        let instructionText = UILabel()
        instructionText.text = "Ask questions by clicking below:"
        instructionText.textColor = .white
        instructionText.textAlignment = .left
        instructionText.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        instructionText.translatesAutoresizingMaskIntoConstraints = false
        border.addSubview(instructionText)
        
        NSLayoutConstraint.activate([
            instructionText.topAnchor.constraint(equalTo: border.topAnchor, constant: 10),
            instructionText.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            textFieldForQuestions.topAnchor.constraint(equalTo: border.topAnchor, constant: 85),
            textFieldForQuestions.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 20),
            textFieldForQuestions.trailingAnchor.constraint(equalTo: border.trailingAnchor, constant: -20),
            textFieldForQuestions.heightAnchor.constraint(equalToConstant: 30),
            
            guessesLeftLabel.topAnchor.constraint(equalTo: border.topAnchor, constant: 85),
            guessesLeftLabel.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: 20),
            guessesLeftLabel.trailingAnchor.constraint(equalTo: border.trailingAnchor, constant: -20),
            guessesLeftLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let defaultButtons = ["Club", "League", "Country", "Position"]
        
        for i in 0..<defaultButtons.count {
            let defaultButton = UIButton(type: .system)
            defaultButton.setTitle(defaultButtons[i], for: .normal)
            defaultButton.backgroundColor = .lightGray
            defaultButton.layer.cornerRadius = 14
            defaultButton.translatesAutoresizingMaskIntoConstraints = false
            border.addSubview(defaultButton)
            
            let leadingOffset:CGFloat = 20 + (20 + 65) * CGFloat(i)
            
            NSLayoutConstraint.activate([
                defaultButton.topAnchor.constraint(equalTo: border.topAnchor, constant: 35),
                defaultButton.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: leadingOffset),
                defaultButton.widthAnchor.constraint(equalToConstant: 65),
                defaultButton.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            originalButtons.append(defaultButton)
            defaultButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            defaultButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.title(for: .normal) else { return }
        
        guessesLeftLabel.isHidden = true
        
        if let lastButton = lastTappedButton {
            if lastButton != sender {
                lastButton.backgroundColor = .lightGray
            }
        }
        
        sender.backgroundColor = model.attemptsLeftDefault >= 1 ? .systemYellow : .lightGray
        lastTappedButton = sender
        
        if model.attemptsLeftDefault < 1 {
            for button in originalButtons {
                button.isEnabled = false
            }
            return
        }
        
        if !extraButtons.isEmpty {
            for button in extraButtons {
                button.removeFromSuperview()
            }
            extraButtons.removeAll()
        }
        textFieldForQuestions.isHidden = false
        model.isTableViewVisible.toggle()
        popUpTableView.isHidden = !model.isTableViewVisible
        popUpTableView.reloadData()
        if model.attemptsLeftDefault == 0 {
            popUpTableView.isHidden = true
        }
        switch buttonTitle {
        case "League":
            leagueButtonTapped(UIButton())
        case "Club":
            clubButtonTapped(UIButton())
        case "Country":
            countryButtonTapped(UIButton())
        case "Position":
            textFieldForQuestions.isHidden = true
            popUpTableView.isHidden = true
            showExtraButtons()
        default:
            break
        }
    }
    
    func clubButtonTapped(_ sender: UIButton) {
        model.selectedCategory = .club
        popUpTableView.reloadData()
        userQuestionsTableView.reloadData()
    }

    func leagueButtonTapped(_ sender: UIButton) {
        model.selectedCategory = .league
        popUpTableView.reloadData()
        userQuestionsTableView.reloadData()
    }

    func countryButtonTapped(_ sender: UIButton) {
        model.selectedCategory = .country
        popUpTableView.reloadData()
        userQuestionsTableView.reloadData()
    }
            
    func showExtraButtons() {
        if !extraButtons.isEmpty {
            for button in extraButtons {
                button.removeFromSuperview()
            }
            extraButtons.removeAll()
            return
        }
        
        model.selectedCategory = .position
        
        let positions = ["GK", "DF", "MF", "FW"]
        
        for i in 0..<positions.count {
            let button = UIButton(type: .system)
            button.setTitle(positions[i], for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 14
            button.translatesAutoresizingMaskIntoConstraints = false
            border.addSubview(button)
            
            let leadingOffset:CGFloat = 20 + (20 + 65) * CGFloat(i)
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: border.topAnchor, constant: 85),
                button.leadingAnchor.constraint(equalTo: border.leadingAnchor, constant: leadingOffset),
                button.widthAnchor.constraint(equalToConstant: 65),
                button.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            extraButtons.append(button)
            button.addTarget(self, action: #selector(extraButtonsTapped), for: .touchUpInside)
        }
    }
    
    @objc func extraButtonsTapped(_ sender: UIButton) {
        guard sender.title(for: .normal) != nil else { return }
        
        if let lastButton = lastTappedButton {
            if lastButton != sender {
                lastButton.backgroundColor = .lightGray
            }
        }
        
        sender.backgroundColor = model.attemptsLeftDefault >= 1 ? .systemYellow : .lightGray
        lastTappedButton = sender
        
        if let selectedTitle = sender.title(for: .normal) {
            if let selectedValue = model.positionMap[selectedTitle] {
                model.attemptsLeftDefault -= 1
                attemptsLeft.text = model.attemptsLeftDefault > 0 ? "You have \(model.attemptsLeftDefault) questions left:" : "You have 0 questions left:"
                model.userSelections.append(selectedValue)
                if model.attemptsLeftDefault < 1 {
                    textFieldForQuestions.isHidden = true
                    for button in extraButtons {
                        button.removeFromSuperview()
                    }
                }
                userQuestionsTableView.reloadData()
            }
        }
    }
    
    @objc func gameOver(isWin: Bool) {
        model.gameOverStatus = true
        textFieldForAnswer.isHidden = true
        textFieldForQuestions.isHidden = true
        border.isHidden = true
        guessesLeftLabel.isHidden = true
        userQuestionsTableView.isHidden = true
        attemptsLeft.isHidden = true
        giveUp.isHidden = true
        
        for ballImage in ballImages {
            ballImage.removeFromSuperview()
        }
        ballImages.removeAll()
        
        let rightAnswerLabel = UILabel()
        rightAnswerLabel.textColor = .white
        rightAnswerLabel.textAlignment = .center
        rightAnswerLabel.font = .boldSystemFont(ofSize: 20)
        rightAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightAnswerLabel)
        
        NSLayoutConstraint.activate([
            rightAnswerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rightAnswerLabel.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 20)
        ])
        
        if isWin {
            rightAnswerLabel.text = "You won! It's Kylian Mbappe!"
            rightAnswer.layer.borderColor = UIColor.green.cgColor
        } else {
            rightAnswerLabel.text = "You lost. It's Kylian Mbappe"
            rightAnswer.layer.borderColor = UIColor.red.cgColor
        }
        
        rightAnswer.layer.borderWidth = 2
        rightAnswer.layer.masksToBounds = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.picture.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.rightAnswer.alpha = 1.0
            })
        }
    }
}
