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
        guard let taskEntityDescription = NSEntityDescription.entity(forEntityName: "Task", in: self.context) else { return }
        let task = Task(entity: taskEntityDescription, insertInto: self.context)
        task.id = id
        task.header = header
        task.desc = desc
        task.isCompleted = isCompleted
        self.appDelegate.saveContext()
    }
        
    func fetchTasks() -> [Todo] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let tasks = try context.fetch(fetchRequest) as? [Task] ?? []
            return tasks.map { task in
                Todo(id: task.id,
                     todo: task.header ?? "",
                     description: task.desc ?? "",
                     date: nil,
                     completed: task.isCompleted)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchTask(_ id: Int32) -> Todo? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try context.fetch(fetchRequest) as? [Task] ?? []
            if let task = tasks.first(where: {$0.id == id}) {
                return Todo(id: task.id,
                            todo: task.header ?? "",
                            description: task.desc ?? "",
                            date: nil,
                            completed: task.isCompleted)
            }
            return nil
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func updateTask(with id: Int32, newHeader: String, newDesc: String?, newIsCompleted: Bool) {
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
    
    public func deleteAllTasks() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            let tasks = try self.context.fetch(fetchRequest) as? [Task]
            tasks?.forEach( {self.context.delete($0)} )
            self.appDelegate.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func deleteTask(with id: Int32) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        do {
            guard let tasks = try self.context.fetch(fetchRequest) as? [Task], let task = tasks.first(where: {$0.id == id} ) else { return }
            self.context.delete(task)
            self.appDelegate.saveContext()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveTasks(from apiTodos: [Todo]) {
        //self.deleteAllTasks()
            
        for apiTodo in apiTodos {
            self.createTask(apiTodo.id, apiTodo.todo, apiTodo.description, apiTodo.completed)
        }
        self.appDelegate.saveContext()
    }
}
