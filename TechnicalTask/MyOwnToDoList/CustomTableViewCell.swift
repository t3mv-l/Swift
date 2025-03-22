//
//  CustomTableViewCell.swift
//  MyOwnToDoList
//
//  Created by Артём on 21.03.2025.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskHeaderLabel: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var isTapped = false
    @IBAction func completingTaskButton(_ sender: UIButton) {
        //если кнопка нажата
        if !isTapped {
            sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            sender.tintColor = .systemYellow
            taskHeaderLabel.textColor = UIColor(named: "CustomColor")
            taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "", attributes: [ .strikethroughStyle: NSUnderlineStyle.single.rawValue])
            taskDescriptionLabel.textColor = UIColor(named: "CustomColor")
        } else {
            //если кнопка отжата обратно
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            sender.tintColor = UIColor(named: "CustomColorDarker")
            taskHeaderLabel.textColor = .white
            taskHeaderLabel.attributedText = NSAttributedString(string: taskHeaderLabel.text ?? "")
            taskDescriptionLabel.textColor = .white
        }
        isTapped.toggle()
    }
}
