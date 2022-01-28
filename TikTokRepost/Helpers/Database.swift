//
//  DataManager.swift
//  TimetableSwift
//
//  Created by Влад Лыков on 13.01.2021.
//

import CoreData

class Database {
    
    static let shared = Database()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return container
    }()
        
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isEntityExist(_ entityName: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return try! context.count(for: fetchRequest) != 0
    }
    
    func getPost(with urlString: String) -> Post? {
        print( "urgfddgl",urlString)
        let fetchRequest = NSFetchRequest<Post>(entityName: "Post")
        fetchRequest.predicate = NSPredicate(format: "ANY url == %@", urlString)
        return try? context.fetch(fetchRequest).first
    }
    
    func deleteCoreDataEntity(_ entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try! context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
    }
    
}
