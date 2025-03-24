//
//  CustomTableViewCell.swift
//  MyOwnToDoList
//
//  Created by Артём on 21.03.2025.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var completingTaskButton: UIButton!
    @IBOutlet weak var taskHeaderLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var isTapped = false
    
    func configureCell(isCompleted: Bool) {
        if isCompleted {
            setCompletedState()
        } else {
            resetState()
        }
    }
    
    private func setCompletedState() {
        completingTaskButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        completingTaskButton.tintColor = .systemYellow
        taskHeaderLabel.textColor = UIColor(named: "CustomColor")
        taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "", attributes: [ .strikethroughStyle: NSUnderlineStyle.single.rawValue])
        taskDescriptionLabel.textColor = UIColor(named: "CustomColor")
        isTapped = true
    }
    
    private func resetState() {
        completingTaskButton.setImage(UIImage(systemName: "circle"), for: .normal)
        completingTaskButton.tintColor = UIColor(named: "CustomColorDarker")
        taskHeaderLabel.textColor = .white
        taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "")
        taskDescriptionLabel.textColor = .white
        isTapped = false
    }
    
    @IBAction func completingTaskButton(_ sender: UIButton) {
        if !isTapped {
            setCompletedState()
        } else {
            resetState()
        }
        isTapped.toggle()
    }
}
