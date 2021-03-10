//
//  CoreDataManager.swift
//  GithubTop
//
//  Created by Владимир Лишаненко on 3/10/21.
//

import CoreData
import Foundation

class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.coreDataModelName)
        container.loadPersistentStores(completionHandler: { _, error in
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

    func createRecordForEntity(_ entity: String) -> NSManagedObject? {
        // Helpers
        let managedObjectContext = persistentContainer.viewContext
        var result: NSManagedObject?

        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)

        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }

        return result
    }

    func fetchRecordsForEntity(_ entity: String, formatPredicate: String = "", object: CVarArg? = nil) -> [NSManagedObject] {
        // Create Fetch Request
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        //Sort
        if object != nil && !formatPredicate.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "\(formatPredicate) == %@", object!)
        }
        
        // Helpers
        var result = [NSManagedObject]()

        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }

        return result
    }

    func deleteRecordForEntity(_ record: NSManagedObject) {
        let managedObjectContext = persistentContainer.viewContext

        managedObjectContext.delete(record)
        saveContext()
    }
}
