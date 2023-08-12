//
//  Persistence.swift
//  Peth Diary
//
//  Created by masbek mbp-m2 on 10/08/23.
//

import CoreData
import CloudKit

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Peth_Diary")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
    }
    
    public func isUserExists(context: NSManagedObjectContext, authID: String, fullName: String, username: String) -> Bool {
        let fetchRequest: NSFetchRequest<Pengguna> = Pengguna.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", authID)

        do {
            let count = try context.count(for: fetchRequest)
            if count != 0 {
                let results = try context.fetch(fetchRequest)
                let objectUpdate = results[0] as NSManagedObject
                // update value
                print(objectUpdate)
                objectUpdate.setValue("\(username) (update)", forKey: "username")
                objectUpdate.setValue(fullName, forKey: "name")
                
                do {
                    try context.save()
                    
                    print("Berhasil UPDATE")
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Update error \(nsError), \(nsError.userInfo)")
                }
                return true
            } else { return false }
            
        } catch {
            print("Error fetching trip count: \(error.localizedDescription)")
            
            return false
            
        }
    }
    
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    
    func fetchAndSyncData(completion: @escaping (Bool) -> Void) {
        let container = CKContainer.default()
        let database = container.publicCloudDatabase
        
        let query = CKQuery(recordType: "CD_Posts", predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching data from CloudKit: \(error)")
                completion(false)
            } else if let records = records {
                DispatchQueue.main.async {
                    self.updateCoreData(with: records)
                    completion(true)
                }
            }
        }
    }
    
    private func updateCoreData(with cloudKitRecords: [CKRecord]) {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for record in cloudKitRecords {
            // Extract data from CKRecord and update Core Data accordingly
            // For example, create or update managed objects based on the CKRecord data
        }
        
        do {
            try viewContext.save() // Save any changes to Core Data
        } catch {
            print("Error saving Core Data changes: \(error)")
        }
    }
    
}
