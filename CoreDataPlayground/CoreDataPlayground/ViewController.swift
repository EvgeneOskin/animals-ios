import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var animals: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Animals"
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData()
    }
    
    @IBAction func addNewAnimal(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Animal",
                                      message: "Add a new animal",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [weak self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self?.save(name: nameToSave)
            self?.table.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        do {
            animals = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("can not add animal \(error)")
        }
    }
    
    func save(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Animal", in: managedContext)!
        let animal = NSManagedObject(entity: entity, insertInto: managedContext)
        
        animal.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            animals.append(animal)
        } catch let error as NSError {
            print("can not add animal \(error)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animal = animals[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = animal.value(forKeyPath: "name") as? String
        return cell
    }
}
