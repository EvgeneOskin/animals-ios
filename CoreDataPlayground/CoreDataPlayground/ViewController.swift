import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var animals: [NSManagedObject] = []
    var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Animals"
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        storage = Storage()
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
        animals = storage.fetchAnimals()
    }
    
    func save(name: String) {
        let animal = storage.createAnimal(name: name)
        storage.save()
        if let animal = animal {
            animals.append(animal)
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
