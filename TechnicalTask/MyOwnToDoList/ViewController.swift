//
//  ViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 21.03.2025.
//

import UIKit

struct Todo: Codable {
    let id: Int32
    let todo: String
    let description: String?
    let date: String?
    let completed: Bool
    
    func toggled() -> Todo {
        CoreDataManager.shared.updateTask(with: id, newHeader: todo, newDesc: description ?? nil, newIsCompleted: !completed)
        return Todo(id: id, todo: todo, description: description, date: date, completed: !completed)
    }
}

struct TodoResponse: Codable {
    let todos: [Todo]
}

class ViewController: UIViewController {
    var todos: [Todo] = []
    var filteredTodos: [Todo] = []
    var isSearching: Bool = false
    var isScrolling: Bool = false
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var bottomToolBar: UIToolbar!
    @IBOutlet var taskListTableView: UITableView!
    var countLabel: UILabel!
    var blurEffectView: UIVisualEffectView?
    var session: URLSession = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBottomToolbar()
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        searchBar.delegate = self
        fetchTodos()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        taskListTableView.addGestureRecognizer(longPressGesture)
        
        CoreDataManager.shared.logCoreDataDBPath()
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
        CoreDataManager.shared.saveTasks(from: todos)
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
                presentDetailView(for: indexPath)
            }
        }
    }
    
    func presentDetailView(for indexPath: IndexPath) {
        let selectedTask = todos[indexPath.row]
        let selectedIndexPath = IndexPath(row: indexPath.row, section: 0)
        
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeViews))
        blurEffectView?.addGestureRecognizer(tapGesture)
        
        if let blurEffectView = blurEffectView {
            view.addSubview(blurEffectView)
            
            let detailView = UIView()
            detailView.backgroundColor = UIColor(named: "CustomColorBottomToolbar")
            detailView.layer.cornerRadius = 10
            detailView.clipsToBounds = true
            detailView.center = view.center
            detailView.bounds.size = CGSize(width: 360, height: 118)
            detailView.alpha = 0
            
            let headerLabel = UILabel()
            headerLabel.text = selectedTask.todo
            headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            headerLabel.textColor = .white
            headerLabel.translatesAutoresizingMaskIntoConstraints = false
            detailView.addSubview(headerLabel)
            
            let descriptionLabel = UILabel()
            descriptionLabel.text = selectedTask.description ?? " "
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.numberOfLines = 2
            descriptionLabel.textColor = .white
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            detailView.addSubview(descriptionLabel)
            
            let dateLabel = UILabel()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            dateFormatter.string(from: Date())
            dateLabel.text = dateFormatter.string(from: Date())
            dateLabel.font = UIFont.systemFont(ofSize: 14)
            dateLabel.textColor = UIColor(named: "CustomColor")
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            detailView.addSubview(dateLabel)
            
            NSLayoutConstraint.activate([
                headerLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
                headerLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
                headerLabel.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 16),
                descriptionLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
                descriptionLabel.trailingAnchor.constraint(equalTo: detailView.trailingAnchor, constant: -16),
                descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
                dateLabel.leadingAnchor.constraint(equalTo: detailView.leadingAnchor, constant: 16),
                dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10)
            ])
            
            blurEffectView.contentView.addSubview(detailView)
            UIView.animate(withDuration: 0.3, animations: {
                detailView.alpha = 1
            }) { _ in
                self.showFunctionMenu(below: detailView, indexPath: selectedIndexPath)
            }
        }
    }
    
    func showFunctionMenu(below detailView: UIView, indexPath: IndexPath) {
        let alertView = UIView(frame: CGRect(x: (view.bounds.width - 300) / 2, y: detailView.frame.maxY + 20, width: 300, height: 150))
        alertView.backgroundColor = UIColor(named: "CustomColorMenu")
        alertView.layer.cornerRadius = 10
        alertView.alpha = 0
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Редактировать                                        ", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.semanticContentAttribute = .forceRightToLeft
        editButton.tintColor = .black
        editButton.contentHorizontalAlignment = .left
        editButton.addTarget(self, action: #selector(editTaskButtonTapped), for: .touchUpInside)
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Поделиться                                           ", for: .normal)
        shareButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.semanticContentAttribute = .forceRightToLeft
        shareButton.tintColor = .black
        shareButton.contentHorizontalAlignment = .left
        shareButton.addTarget(self, action: #selector(shareTaskButtonTapped), for: .touchUpInside)
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Удалить                                               ", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.semanticContentAttribute = .forceRightToLeft
        deleteButton.tintColor = .red
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.addTarget(self, action: #selector(deleteTaskButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(editButton)
        
        let editShareSeparator = UIView()
        editShareSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        editShareSeparator.backgroundColor = UIColor.lightGray
        stackView.addArrangedSubview(editShareSeparator)
        stackView.addArrangedSubview(shareButton)
        
        let shareDeleteSeparator = UIView()
        shareDeleteSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        shareDeleteSeparator.backgroundColor = UIColor.lightGray
        stackView.addArrangedSubview(shareDeleteSeparator)
        stackView.addArrangedSubview(deleteButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(stackView)
        
        if let blurEffectView = blurEffectView {
            blurEffectView.contentView.addSubview(alertView)
            
            NSLayoutConstraint.activate([
                editButton.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
                editButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
                editShareSeparator.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
                editShareSeparator.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
                shareDeleteSeparator.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
                shareDeleteSeparator.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
                stackView.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
                stackView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20)
            ])
            
            UIView.animate(withDuration: 0.3, animations: {
                alertView.alpha = 1
            })
        }
        
        editButton.tag = indexPath.row
        shareButton.tag = indexPath.row
        deleteButton.tag = indexPath.row
    }
    
    @objc func closeViews() {
        for subview in view.subviews {
            if let blurEffectView = subview as? UIVisualEffectView {
                UIView.animate(withDuration: 0.3, animations: {
                    blurEffectView.alpha = 0
                }) { _ in
                    blurEffectView.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func editTaskButtonTapped(sender: UIButton) {
        closeViews()
        let indexPath = sender.tag
        editTask(at: IndexPath(row: indexPath, section: 0))
    }
    
    @objc func shareTaskButtonTapped(sender: UIButton) {
        closeViews()
        let indexPath = sender.tag
        shareTask(at: IndexPath(row: indexPath, section: 0))
    }
    
    @objc func deleteTaskButtonTapped(sender: UIButton) {
        closeViews()
        let indexPath = sender.tag
        deleteTask(at: IndexPath(row: indexPath, section: 0))
    }
    
    func editTask(at indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskVC = storyboard.instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        createTaskVC.delegate = self
        createTaskVC.existingTodos = todos
        let task = todos[indexPath.row]
        let header = task.todo
        let desc = task.description
        let date = task.date
        let isCompleted = task.completed
        createTaskVC.taskToEdit = (title: header, description: desc ?? "", date: date ?? "", completed: isCompleted)
        createTaskVC.editingIndex = indexPath.row
        self.navigationController?.pushViewController(createTaskVC, animated: true)
    }
    
    func shareTask(at indexPath: IndexPath) {
        let vc = UIActivityViewController(activityItems: ["\(todos[indexPath.row].todo)\n\(todos[indexPath.row].description ?? "")"], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.view
        present(vc, animated: true)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        todos.remove(at: indexPath.row)
        CoreDataManager.shared.deleteTask(with: Int32(indexPath.row + 1))
        //todos = CoreDataManager.shared.fetchTasks()
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
        return isSearching ? filteredTodos.count : todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        let todo = isSearching ? filteredTodos[indexPath.row] : todos[indexPath.row]
        cell.configureCell(isCompleted: todo.completed, taskHeader: todo.todo, taskDescription: todo.description ?? " ", date: getCurrentDateString())
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
        if searchText.isEmpty {
            isSearching = false
            filteredTodos.removeAll()
        } else {
            isSearching = true
            filteredTodos = todos.filter { todo in
                return todo.todo.lowercased().contains(searchText.lowercased()) || (todo.description?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            countLabel.text = "\(filteredTodos.count) Задач"
        }
        taskListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
}

extension ViewController: CreateTaskViewControllerDelegate {
    func addNewTask(todo: Todo, description: String?, date: String) {
        let newTodo = Todo(id: todo.id, todo: todo.todo, description: description, date: getCurrentDateString(), completed: todo.completed)
        todos.append(newTodo)
        let newId = Int32(todos.count)
        CoreDataManager.shared.createTask(newId, newTodo.todo, newTodo.description, newTodo.completed)
        //todos = CoreDataManager.shared.fetchTasks()
        taskListTableView.reloadData()
        countLabel.text = "\(todos.count) Задач"
    }
    
    func updateTask(at index: Int, todo: Todo, description: String?, date: String) {
        todos[index] = todo
        //todos = CoreDataManager.shared.fetchTasks()
        taskListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}
