//
//  CoreDataManager.swift
//  MyOwnToDoList
//
//  Created by Артём on 25.03.2025.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    public func logCoreDataDBPath() {
        if let url = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
            print("Data base url: \(url)")
        }
    }
    
    public func createTask(_ id: Int32, _ header: String, _ desc: String?, _ isCompleted: Bool) {
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let task = Task(entity: taskEntityDescription, insertInto: context)
        task.id = id
        task.header = header
        task.desc = desc
        task.isCompleted = isCompleted
        appDelegate.saveContext()
    }
        
    public func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            return try context.fetch(fetchRequest) as! [Task]
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    public func fetchTask(_ id: Int32) -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try? context.fetch(fetchRequest) as? [Task]
            return tasks?.first(where: {$0.id == id})
        }
    }
    
    public func updateTask(with id: Int32, newHeader: String, newDesc: String?, newIsCompleted: Bool) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try context.fetch(fetchRequest) as? [Task], let task = tasks.first(where: {$0.id == id }) else { return }
            task.header = newHeader
            task.desc = newDesc
            task.isCompleted = newIsCompleted
            appDelegate.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteAllTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try context.fetch(fetchRequest) as? [Task]
            tasks?.forEach( {context.delete($0)} )
            appDelegate.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteTask(with id: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try context.fetch(fetchRequest) as? [Task], let task = tasks.first(where: {$0.id == id} ) else { return }
            context.delete(task)
            appDelegate.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveTasks(from apiTodos: [Todo]) {
        deleteAllTasks()
            
        for apiTodo in apiTodos {
            createTask(apiTodo.id, apiTodo.todo, apiTodo.description, apiTodo.completed)
        }
    }
}
