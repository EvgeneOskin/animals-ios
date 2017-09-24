import UIKit
import CoreData

class Storage {
    let container: NSPersistentContainer!
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.container.newBackgroundContext()
    }()
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Can not get shared app delegate")
        }
        self.init(container: appDelegate.persistentContainer)
    }
    
    func createAnimal(name: String) -> Animal? {
        guard let animal = NSEntityDescription.insertNewObject(forEntityName: "Animal", into: backgroundContext) as? Animal else {
            return nil
        }
        animal.name = name
        return animal
    }
    
    func fetchAnimals() -> [Animal] {
        let request: NSFetchRequest<Animal> = Animal.fetchRequest()
        let results = try? container.viewContext.fetch(request)
        return results ?? [Animal]()
    }
    
    func save() {
        if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
}
