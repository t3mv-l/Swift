//
//  СreateTaskViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 22.03.2025.
//

import UIKit

protocol CreateTaskViewControllerDelegate: AnyObject {
    func addNewTask(todo: Todo, description: String?, date: String)
    func updateTask(at index: Int, todo: Todo, description: String?, date: String)
}

class CreateTaskViewController: UIViewController {
    var taskToEdit: (title: String, description: String, date: String, completed: Bool)?
    var editingIndex: Int?
    weak var delegate: CreateTaskViewControllerDelegate?
    var existingTodos: [Todo] = []

    @IBOutlet var createTaskTextView: UITextView!
    
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
            setUpTextView(for: task)
            editingIndex = editingIndex ?? nil
        }
    }
    
    private func setUpTextView(for task: (title: String, description: String, date: String, completed: Bool)) {
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
    
    @IBAction func newTaskCreatedButton(_ sender: UIButton) {
        let fullText = createTaskTextView.text ?? ""
        guard !fullText.isEmpty else { return }
        let components = fullText.components(separatedBy: .newlines)
        let title = components.first ?? ""
        let description = components.dropFirst().joined(separator: "\n")
        
        if let editingIndex = editingIndex {
            let completedStatus = existingTodos[editingIndex].completed
            let updatedTodo = Todo(id: existingTodos[editingIndex].id, todo: title, description: description, date: getCurrentDateString(), completed: completedStatus)
            delegate?.updateTask(at: editingIndex, todo: updatedTodo, description: description, date: getCurrentDateString())
        } else {
            // Получаем максимальный id из существующих задач, чтобы не было конфликтов
            let maxId = CoreDataManager.shared.fetchTasks().map { $0.id }.max() ?? 0//existingTodos.map { $0.id }.max() ?? 0
            let newID = maxId + 1
            let newTodo = Todo(id: newID, todo: title, description: description, date: getCurrentDateString(), completed: false)
            delegate?.addNewTask(todo: newTodo, description: description, date: getCurrentDateString())
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: Date())
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
