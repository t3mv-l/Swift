//
//  ViewController.swift
//  MyOwnToDoList
//
//  Created by Артём on 21.03.2025.
//

import UIKit

class ViewController: UIViewController {
    let taskList = ["Почитать книгу", "Уборка в квартире", "Заняться спортом", "Работа над проектом", "Вечерний отдых", "Зарядка утром", "Какая-то ещё задача, чтобы типа 7 задач было"]
    let descriptionList = ["Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике", "Провести генеральную уборку в квартире", "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!", "Выделить время для работы над проектом на работе. Сфокусироваться на выполнении важных задач", "Найти время для расслабления перед сном: посмотреть фильм или послушать музыку", "Сделать утреннюю зарядку", "Описание для седьмой задачи"]
    let dateList : [String] = ["09/10/24", "02/10/24", "02/10/24", "09/10/24", "02/10/24", "02/10/24", "09/10/24"]
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var taskListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskListTableView.dataSource = self
        taskListTableView.delegate = self
        
        let label = UILabel()
        label.textColor = .white
        label.text = "\(taskList.count) Задач"
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.sizeToFit()
        let labelItem = UIBarButtonItem(customView: label)
        
        let flexibleSpaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexibleSpaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let createTaskButton = UIBarButtonItem(title: "", image: UIImage(systemName: "square.and.pencil"), target: self, action: #selector(createTaskButtonTapped))
        createTaskButton.tintColor = .systemYellow
        
        bottomToolBar.setItems([flexibleSpaceLeft, labelItem, flexibleSpaceRight, createTaskButton], animated: false)
    }
    
    @objc func createTaskButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let createTaskViewController = storyboard.instantiateViewController(withIdentifier: "CreateTaskViewController") as! createTaskViewController
        self.navigationController?.pushViewController(createTaskViewController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.taskHeaderLabel.text = taskList[indexPath.row]
        cell.taskDescriptionLabel.text = descriptionList[indexPath.row]
        cell.dateLabel.text = dateList[indexPath.row]
        cell.dateLabel.textColor = UIColor(named: "CustomColor")
        cell.backgroundColor = .black
        cell.taskHeaderLabel.textColor = .white
        cell.taskDescriptionLabel.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}
