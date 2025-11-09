//
//  CoreDataStack.swift
//  DragonballChars
//
//  Created by Sujith Bolisetty on 08/11/25.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack(modelName: "DragonballChars")
    
    let container : NSPersistentContainer
    
    private init(modelName : String) {
        self.container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores{storeDesc, error in
            
            if let err = error {
                fatalError("Unresoved Core data error: \(err)")
            }
            
            // Use automatic merging so background saves appear on main context
            self.container.viewContext.automaticallyMergesChangesFromParent = true
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    var viewContext : NSManagedObjectContext {
        container.viewContext
    }
    
    func newBackgrounContext() -> NSManagedObjectContext {
        let ctx = container.newBackgroundContext()
        ctx.automaticallyMergesChangesFromParent = true
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return ctx
    }
    
    func performBackgroundTask(_ block : @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask(block)
    }
}

