//
//  CoreDataStack.swift
//  WidgetWrite
//
//  Created by Jonathan Wei on 2022-08-12.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() {}
    
    private let persistentContainer: NSPersistentContainer = {
        let storeURL = FileManager.appGroupContainerURL.appendingPathComponent("DataModel.sqlite")
        let container = NSPersistentContainer(name: "DataModel")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                print(error.localizedDescription)
            }
        })
        return container
    }()
}
