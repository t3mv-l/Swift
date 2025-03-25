//
//  Task+CoreDataProperties.swift
//  MyOwnToDoList
//
//  Created by Артём on 25.03.2025.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int32
    @NSManaged public var header: String?
    @NSManaged public var desc: String?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
