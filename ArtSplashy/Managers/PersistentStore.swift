//
//  PersistentStore.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 28.01.24.
//

import Foundation
import CoreData

struct PersistentStore {
    
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    static let shared = PersistentStore()
    
    init() {
        container = NSPersistentContainer(name: "Postings")
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error with Core Data: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error as NSError {
            NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
        }
    }
    
}
