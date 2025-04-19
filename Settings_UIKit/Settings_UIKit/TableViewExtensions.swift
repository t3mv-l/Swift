//
//  TableViewExtensions.swift
//  Settings_UIKit
//
//  Created by Артём on 19.04.2025.
//

import UIKit

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredSections.count
        }
        
        switch section {
        case 0:
            return zeroSection.count
        case 1:
            return firstSection.count
        case 2:
            return secondSection.count
        case 3:
            return thirdSection.count
        case 4:
            return fourthSection.count
        case 5:
            return fifthSection.count
        case 6:
            return sixthSection.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        
        if searchController.isActive {
            let sectionInfo = filteredSections[indexPath.row]
            config.text = sectionInfo.title
            config.image = sectionInfo.systemPic
            config.secondaryText = sectionInfo.subtitle
        } else {
            switch indexPath.section {
            case 0:
                config.text = zeroSection[indexPath.row].title
                config.textProperties.font = .systemFont(ofSize: 20, weight: .bold)
                config.image = zeroSection[indexPath.row].systemPic
                config.secondaryText = zeroSection[indexPath.row].subtitle
            case 1:
                config.text = firstSection[indexPath.row].title
                config.image = firstSection[indexPath.row].systemPic
                config.secondaryText = firstSection[indexPath.row].subtitle
            case 2:
                config.text = secondSection[indexPath.row].title
                config.image = secondSection[indexPath.row].systemPic
            case 3:
                config.text = thirdSection[indexPath.row].title
                config.image = thirdSection[indexPath.row].systemPic
            case 4:
                config.text = fourthSection[indexPath.row].title
                config.image = fourthSection[indexPath.row].systemPic
            case 5:
                config.text = fifthSection[indexPath.row].title
                config.image = fifthSection[indexPath.row].systemPic
            case 6:
                config.text = sixthSection[indexPath.row].title
                config.image = sixthSection[indexPath.row].systemPic
            default: break
            }
        }
        cell.contentConfiguration = config
        
        if config.text == "VPN" || config.text == "Авиарежим" {
            let toggle = UISwitch()
            toggle.isOn = false
            cell.accessoryView = toggle
        } else {
            cell.accessoryView = nil
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
