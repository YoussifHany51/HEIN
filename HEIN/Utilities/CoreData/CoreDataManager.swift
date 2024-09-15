//
//  CoreDataManager.swift
//  HEIN
//
//  Created by Youssif Hany on 14/09/2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteProduct")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

