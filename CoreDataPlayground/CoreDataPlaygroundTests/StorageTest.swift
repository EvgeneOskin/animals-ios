//
//  CoreDataPlaygroundTests.swift
//  CoreDataPlaygroundTests
//
//  Created by Eugene Oskin on 24.09.17.
//  Copyright © 2017 Crystalnix. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreDataPlayground

class CoreDataPlaygroundTests: XCTestCase {
    
    var storage: Storage!
    
    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Animals", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    override func setUp() {
        super.setUp()
        
        initStubs()
        storage = Storage(container: mockContainer)
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func initStubs() {
        
        func insertAnimal(name: String) -> Animal? {
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Animal", into: mockContainer.viewContext)
            
            obj.setValue(name, forKey: "name")
            return obj as? Animal
        }
        
        _ = insertAnimal(name: "1")
        
        do {
            try mockContainer.viewContext.save()
        } catch {
            print("create fakes error \(error)")
        }
    }
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Animal")
        let objs = try! mockContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockContainer.viewContext.delete(obj)
        }
        try! mockContainer.viewContext.save()
        
    }
    
    func testCreate() {
        let name = "ping"
        let animal = storage.createAnimal(name: name)
        
        XCTAssertNotNil(animal)
    }
    
    func testFetchAll() {
        let results = storage.fetchAnimals()
        XCTAssertEqual(results.count, 1)
    }
    
}
