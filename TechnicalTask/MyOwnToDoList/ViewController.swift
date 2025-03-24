//
//  ViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 21.03.2025.
//

import UIKit

struct Todo: Codable {
    let id: Int
    let todo: String
    let description: String?
    let date: String?
    let completed: Bool
    
    func toggled() -> Todo {
        return Todo(id: id, todo: todo, description: description, date: date, completed: !completed)
    }
}

struct TodoResponse: Codable {
    let todos: [Todo]
}

class ViewController: UIViewController {
    var todos: [Todo] = []
    var isSearching: Bool = false
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var taskListTableView: UITableView!
    var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBottomToolbar()
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        searchBar.delegate = self
        fetchTodos()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        taskListTableView.addGestureRecognizer(longPressGesture)
    }
    
    func drawBottomToolbar() {
        countLabel = UILabel()
        countLabel.textColor = .white
        countLabel.font = .systemFont(ofSize: 13)
        countLabel.textAlignment = .center
        countLabel.numberOfLines = 1
        countLabel.lineBreakMode = .byWordWrapping
        countLabel.sizeToFit()
        let labelItem = UIBarButtonItem(customView: countLabel)
        
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let createTaskButton = UIBarButtonItem(title: "", image: UIImage(systemName: "square.and.pencil"), target: self, action: #selector(createTaskButtonTapped))
        createTaskButton.tintColor = .systemYellow
        
        bottomToolBar.setItems([flexibleSpaceLeft, labelItem, flexibleSpaceRight, createTaskButton], animated: false)
    }
    
    func fetchTodos() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching todos: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                self.processTodos(decodedResponse.todos)
            } catch {
                print("Error coding JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    func processTodos(_ todos: [Todo]) {
        DispatchQueue.main.async {
            self.todos = todos
            self.taskListTableView.reloadData()
            self.countLabel.text = "\(self.todos.count) Задач"
            self.countLabel.sizeToFit()
        }
    }
    
    private func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: Date())
    }
    
    @objc func createTaskButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskViewController = storyboard.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        createTaskViewController.delegate = self
        self.navigationController?.pushViewController(createTaskViewController, animated: true)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: taskListTableView)
            if let indexPath = taskListTableView.indexPathForRow(at: point) {
                showEditOptions(for: indexPath)
            }
        }
    }
    
    func showEditOptions(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "Редактировать", style: .default) { [weak self] _ in
            self?.editTask(at: indexPath) }
        editAction.setValue(UIImage(systemName: "square.and.pencil"), forKey: "image")
        let shareAction = UIAlertAction(title: "Поделиться", style: .default) { [weak self] _ in
            self?.shareTask(at: indexPath) }
        shareAction.setValue(UIImage(systemName: "square.and.arrow.up"), forKey: "image")
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive)  { [weak self] _ in
            self?.deleteTask(at: indexPath) }
        deleteAction.setValue(UIImage(systemName: "trash"), forKey: "image")

        alertController.addAction(editAction)
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true)
    }
    
    func editTask(at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskVC = storyboard.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        createTaskVC.delegate = self
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func shareTask(at indexPath: IndexPath) {
        let vc = UIActivityViewController(activityItems: ["\(todos[indexPath.row])"], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.view
        present(vc, animated: true)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row)
        taskListTableView.reloadData()
        countLabel.text = "\(todos.count) Задач"
    }
    
    private func toggleTodoCompletion(at index: Int) {
        todos[index] = todos[index].toggled()
        taskListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let todo = todos[indexPath.row]
        cell.configureCell(isCompleted: todo.completed, taskHeader: todo.todo, taskDescription: todo.description ?? "Random description", date: getCurrentDateString())
        cell.onCompletingTaskButtonTapped = { [weak self] in
            self?.toggleTodoCompletion(at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //реализовать
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //реализовать
    }
}

extension ViewController: CreateTaskViewControllerDelegate {
    func addNewTask(todo: Todo, description: String?, date: String) {
        let newTodo = Todo(id: todo.id, todo: todo.todo, description: description, date: getCurrentDateString(), completed: todo.completed)
        todos.append(newTodo)
        taskListTableView.reloadData()
        countLabel.text = "\(todos.count) Задач"
    }
    
    func updateTask(at index: Int, task: String, description: String, date: String) {
        //реализовать
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let newTaskVC = segue.destination as? CreateTaskViewController {
//            newTaskVC.delegate = self
//            newTaskVC.existingTodos = self.todos
//            //реализовать
//        }
//    }
}

//альтернатива AlertController для меню
//        let alertView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
//        alertView.backgroundColor = UIColor(named: "CustomColorMenu")
//        alertView.layer.cornerRadius = 10
//        alertView.center = self.view.center
//
//        let editButton = UIButton(type: .system)
//        editButton.setTitle("Редактировать", for: .normal)
//        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
//        editButton.semanticContentAttribute = .forceRightToLeft
//        editButton.tintColor = .black
//        editButton.contentHorizontalAlignment = .left
//        editButton.addTarget(self, action: #selector(editTask), for: .touchUpInside)
//        let shareButton = UIButton(type: .system)
//        shareButton.setTitle("Поделиться", for: .normal)
//        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
//        shareButton.semanticContentAttribute = .forceRightToLeft
//        shareButton.tintColor = .black
//        shareButton.contentHorizontalAlignment = .left
//        shareButton.addTarget(self, action: #selector(shareTask), for: .touchUpInside)
//        let deleteButton = UIButton(type: .system)
//        deleteButton.setTitle("Удалить", for: .normal)
//        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
//        deleteButton.semanticContentAttribute = .forceRightToLeft
//        deleteButton.tintColor = .red
//        deleteButton.contentHorizontalAlignment = .left
//        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
//
//        let stackView = UIStackView(arrangedSubviews: [editButton, shareButton, deleteButton])
//        stackView.axis = .vertical
//        stackView.spacing = 20
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        alertView.addSubview(stackView)
//        view.addSubview(alertView)
//
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
//        ])
