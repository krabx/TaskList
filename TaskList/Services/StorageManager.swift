//
//  StorageManager.swift
//  TaskList
//
//  Created by Богдан Радченко on 04.04.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchData() -> [Task] {
        var list: [Task] = []
        let fetchRequest = Task.fetchRequest()
        let context = persistentContainer.viewContext
        
        do {
            list = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return list
    }
    
    func delete(taskName: Task) {
        let context = persistentContainer.viewContext
        context.delete(taskName)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private init() {}
}
