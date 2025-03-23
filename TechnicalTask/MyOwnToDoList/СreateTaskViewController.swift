//
//  СreateTaskViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 22.03.2025.
//

import UIKit

protocol CreateTaskViewControllerDelegate: AnyObject {
    func addNewTask(task: String, description: String, date: String)
    func updateTask(at index: Int, task: String, description: String, date: String)
}

class CreateTaskViewController: UIViewController {
    var taskToEdit: (title: String, description: String, date: String)?
    var editingIndex: Int?
    weak var delegate: CreateTaskViewControllerDelegate?

    @IBOutlet weak var createTaskTextView: UITextView!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTaskTextView.delegate = self
        
        view.backgroundColor = .black
        createTaskTextView.backgroundColor = .black
        createTaskTextView.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        createTaskTextView.textColor = .white
        self.overrideUserInterfaceStyle = .dark
        
        if let task = taskToEdit {
            let attributedString = NSMutableAttributedString()
            
            let titleAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 40, weight: .bold), .foregroundColor: UIColor.white]
            let titleString = NSAttributedString(string: task.title, attributes: titleAttributes)
            attributedString.append(titleString)
            attributedString.append(NSAttributedString(string: "\n\n"))
            
            let dateAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(named: "CustomColor")!]
            let dateString = NSAttributedString(string: task.date, attributes: dateAttributes)
            attributedString.append(dateString)
            attributedString.append(NSAttributedString(string: "\n\n"))
            
            let descriptionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.white]
            let descriptionString = NSAttributedString(string: task.description, attributes: descriptionAttributes)
            attributedString.append(descriptionString)
            
            createTaskTextView.attributedText = attributedString
        }
    }
    
    @IBAction func newTaskCreatedButton(_ sender: UIButton) {
        let fullText = createTaskTextView.text ?? ""
        let components = fullText.components(separatedBy: .newlines)
        
        let title = components.first ?? ""
        let description = components.dropFirst().joined(separator: "\n")
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateString = dateFormatter.string(from: currentDate)
        
        if let index = editingIndex {
            delegate?.updateTask(at: index, task: title, description: description, date: dateString)
        } else {
            delegate?.addNewTask(task: title, description: description, date: dateString)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createTaskTextView.becomeFirstResponder()
    }
}

extension CreateTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            let currentText = textView.text as NSString
            let newText = currentText.replacingCharacters(in: range, with: text)
            
            let attributedText = NSMutableAttributedString(string: newText)
            
            if range.location > 0 {
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 40, weight: .bold), range: NSRange(location: 0, length: range.location))
                attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: range.location))
            }
            
            attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 20), range: NSRange(location: range.location, length: attributedText.length - range.location))
            attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: range.location, length: attributedText.length - range.location))
            
            textView.attributedText = attributedText
            
            let newPosition = textView.position(from: textView.endOfDocument, offset: 0)
            textView.selectedTextRange = textView.textRange(from: newPosition!, to: newPosition!)
            
            return false
        }
        return true
    }
}
