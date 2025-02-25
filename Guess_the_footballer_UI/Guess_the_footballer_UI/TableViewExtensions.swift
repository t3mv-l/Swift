//
//  TableViewExtensions.swift
//  Test_cases
//
//  Created by Артём on 24.02.2025.
//

import UIKit

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == popUpTableView {
            switch model.selectedCategory {
            case .club:
                return model.clubStringValues.count
            case .league:
                return model.leagueStringValues.count
            case .country:
                return model.countryStringValues.count
            case .position:
                return 0
            }
        } else {
            return model.userSelections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popUpTableView {
            let cell = popUpTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            cell.contentView.subviews.forEach{ $0.removeFromSuperview() }
            
            let imageView = UIImageView()
            let label = UILabel()
            
            switch model.selectedCategory {
            case .club:
                imageView.image = UIImage(named: model.clubImageViews[indexPath.row])
                label.text = model.clubStringValues[indexPath.row]
            case .league:
                imageView.image = UIImage(named: model.leagueImageViews[indexPath.row])
                label.text = model.leagueStringValues[indexPath.row]
            case .country:
                imageView.image = UIImage(named: model.countryImageViews[indexPath.row])
                label.text = model.countryStringValues[indexPath.row]
            case .position:
                break
            }
            
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(imageView)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .white
            cell.contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 20),
                imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                imageView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            
            cell.backgroundColor = .black
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            cell.textLabel?.backgroundColor = .black
            
            return cell
        } else if tableView == userQuestionsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserQuestionsCell", for: indexPath)
            cell.backgroundColor = .black
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            cell.textLabel?.backgroundColor = .black
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = .boldSystemFont(ofSize: 19)
            let selectedValue = model.userSelections[indexPath.row]
            
            if model.userAnswers.count <= indexPath.row {
                model.userAnswers.append("")
            }
            
            switch model.selectedCategory {
            case .club:
                if model.userAnswers[indexPath.row].isEmpty {
                    model.userAnswers[indexPath.row] = selectedValue == "Real Madrid" ? "He plays for \(selectedValue): \(guess[0])" : "He plays for \(selectedValue): \(guess[1])"
                }
            case .league:
                if model.userAnswers[indexPath.row].isEmpty {
                    model.userAnswers[indexPath.row] = selectedValue == "LaLiga" ? "He plays in \(selectedValue): \(guess[0])" : "He plays in \(selectedValue): \(guess[1])"
                }
            case .country:
                if model.userAnswers[indexPath.row].isEmpty {
                    model.userAnswers[indexPath.row] = selectedValue == "France" ? "He is from \(selectedValue): \(guess[0])" : "He is from \(selectedValue): \(guess[1])"
                }
            case .position:
                if model.userAnswers[indexPath.row].isEmpty {
                    model.userAnswers[indexPath.row] = selectedValue == "forward" ? "He plays as a \(selectedValue): \(guess[0])" : "He plays as a \(selectedValue): \(guess[1])"
                }
            }
            cell.textLabel?.text = model.userAnswers[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == popUpTableView ? 25 : 38
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if model.userSelections.count < model.maxSelections {
            model.attemptsLeftDefault -= 1
            attemptsLeft.text = model.attemptsLeftDefault > 0 ? "You have \(model.attemptsLeftDefault) questions left:" : "You have 0 questions left:"
            
            switch model.selectedCategory {
            case .club:
                let selectedValue = model.clubStringValues[indexPath.row]
                model.userSelections.append(selectedValue)
                userQuestionsTableView.reloadData()
            case .league:
                let selectedValue = model.leagueStringValues[indexPath.row]
                model.userSelections.append(selectedValue)
                userQuestionsTableView.reloadData()
            case .country:
                let selectedValue = model.countryStringValues[indexPath.row]
                model.userSelections.append(selectedValue)
                userQuestionsTableView.reloadData()
            case .position:
                break
            }
            
            model.isTableViewVisible = false
            popUpTableView.isHidden = true
            userQuestionsTableView.reloadData()
        }
    }
}
