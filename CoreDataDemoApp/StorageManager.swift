//
//  StorageManager.swift
//  CoreDataDemoApp
//
//  Created by Evgenia Shipova on 01.10.2020.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData(for object: [Task]) ->  [Task] {
        var tasks = object
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            tasks = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        
        return tasks
    }
    
    // MARK: - Core Data Saving support
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
    
    // MARK: - Core Data Delete
    func deleteContext(_ object: Task) {
        let context = persistentContainer.viewContext
        
        context.delete(object)
        
        saveContext()
    }
    
    // MARK: - Core Data Edit
    func saveEditContext(_ taskName: String, at indexPath: IndexPath) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        let context = persistentContainer.viewContext
        
        do {
            let results = try context.fetch(fetchRequest) as? [Task]
            
            let  task = results?[indexPath.row]
            task?.name = taskName
        } catch {
            print(error)
        }
        
        saveContext()
    }
}
