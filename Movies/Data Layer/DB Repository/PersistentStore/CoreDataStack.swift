//
//  CoreDataStack.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import CoreData

enum PersistentStoreError: Error {
    case unknown(error: String)
}

protocol PersistentStore {
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) async throws -> [Item]
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) async throws -> Item
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) async throws
}

struct CoreDataStack: PersistentStore {
    static let modelName = "MovieModel"
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: Self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func fetch<Item>(_ fetchRequest: NSFetchRequest<Item>) async throws -> [Item] {
        let context = container.viewContext
        return try await context.perform {
            do {
                let resultItems = try context.fetch(fetchRequest)
                return resultItems
            } catch let error {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
    
    func update<Item>(fetchRequest: NSFetchRequest<Item>, update: @escaping (Item) -> Void, createNew: @escaping (NSManagedObjectContext) -> Item) async throws -> Item {
        let context = container.newBackgroundContext()
        
        return try await context.perform {
            do {
                var resultItem: Item
                if let itemsToUpdate = try context.fetch(fetchRequest).first {
                    update(itemsToUpdate)
                    resultItem = itemsToUpdate
                } else {
                    resultItem = createNew(context)
                }
                
                guard context.hasChanges else {
                    context.reset()
                    return resultItem
                }
                
                try context.save()
                return resultItem
            } catch {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
    
    func delete<Item: NSManagedObject>(_ fetchRequest: NSFetchRequest<Item>) async throws -> Void {
        let context = container.newBackgroundContext()
        
        return try await context.perform {
            do {
                let itemsToDelete = try context.fetch(fetchRequest)
                itemsToDelete.forEach {
                    context.delete($0)
                }
                
                guard context.hasChanges else {
                    context.reset()
                    return
                }
                try context.save()
                return
            } catch {
                context.reset()
                throw PersistentStoreError.unknown(error: error.localizedDescription)
            }
        }
    }
}
