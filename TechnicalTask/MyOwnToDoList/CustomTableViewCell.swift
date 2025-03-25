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
    var onCompletingTaskButtonTapped: (() -> Void)?
    
    func configureCell(isCompleted: Bool, taskHeader: String, taskDescription: String, date: String) {
        taskHeaderLabel.text = taskHeader
        taskDescriptionLabel.text = taskDescription
        dateLabel.text = date
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
        
        //taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "", attributes: [ .strikethroughStyle: NSUnderlineStyle.single.rawValue])
        
        taskDescriptionLabel.textColor = UIColor(named: "CustomColor")
        isTapped = true
    }
    
    private func resetState() {
        completingTaskButton.setImage(UIImage(systemName: "circle"), for: .normal)
        completingTaskButton.tintColor = UIColor(named: "CustomColorDarker")
        //taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "")
        taskHeaderLabel.textColor = .white
        taskDescriptionLabel.textColor = .white
        isTapped = false
    }
    
    @IBAction func completingTaskButton(_ sender: UIButton) {
        onCompletingTaskButtonTapped?()
    }
}
