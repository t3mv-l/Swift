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
    //private override init() {}
        
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
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
        DispatchQueue.main.async {
            guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: self.context) else { return }
            let task = Task(entity: taskEntityDescription, insertInto: self.context)
            task.id = id
            task.header = header
            task.desc = desc
            task.isCompleted = isCompleted
            self.appDelegate.saveContext()
        }
    }
        
    public func fetchTasks() -> [Task] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            return (try? context.fetch(fetchRequest) as? [Task]) ?? []
        } 
    }
    
    public func fetchTask(_ id: Int32) -> Task? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try? context.fetch(fetchRequest) as? [Task]
            return tasks?.first(where: {$0.id == id})
        }
    }
    
    public func updateTask(with id: Int32, newHeader: String, newDesc: String?, newIsCompleted: Bool) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do {
                guard let tasks = try self.context.fetch(fetchRequest) as? [Task], let task = tasks.first(where: {$0.id == id }) else { return }
                task.header = newHeader
                task.desc = newDesc
                task.isCompleted = newIsCompleted
                self.appDelegate.saveContext()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func deleteAllTasks() {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do {
                let tasks = try self.context.fetch(fetchRequest) as? [Task]
                tasks?.forEach( {self.context.delete($0)} )
                self.appDelegate.saveContext()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func deleteTask(with id: Int32) {
        DispatchQueue.main.async {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            do {
                guard let tasks = try self.context.fetch(fetchRequest) as? [Task], let task = tasks.first(where: {$0.id == id} ) else { return }
                self.context.delete(task)
                self.appDelegate.saveContext()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveTasks(from apiTodos: [Todo]) {
        DispatchQueue.main.async {
            self.deleteAllTasks()
            
            for apiTodo in apiTodos {
                self.createTask(apiTodo.id, apiTodo.todo, apiTodo.description, apiTodo.completed)
            }
        }
    }
}
