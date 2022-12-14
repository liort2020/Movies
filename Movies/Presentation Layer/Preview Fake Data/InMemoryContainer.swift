//
//  InMemoryContainer.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import CoreData

#if DEBUG
struct InMemoryContainer {
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName)
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        return container
    }()
}
#endif
