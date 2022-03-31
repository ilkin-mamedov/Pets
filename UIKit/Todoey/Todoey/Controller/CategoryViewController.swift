import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")!
        
        let appearance = UINavigationBarAppearance();
        appearance.backgroundColor = UIColor(named: "BarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        load()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)

        alert.view.tintColor = UIColor(named: "AlertColor")
        
        alert.addTextField { textField in textField.placeholder = "Enter a title of your category" }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { action in
            if let title = alert.textFields![0].text, !title.isEmpty {
                let category = Category()
                category.title = title
                
                self.save(category: category)
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: {
            alert.view.tintColor = UIColor(named: "AlertColor")
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.title ?? "Not categories added yet"
        cell.textLabel?.textColor = UIColor(named: "TextColor")!
        
        let backgroundViewCell = UIView()
        backgroundViewCell.backgroundColor = UIColor(named: "CellColor")!
        cell.selectedBackgroundView = backgroundViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category.items)
                        realm.delete(category)
                    }
                } catch {
                    print(error)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories?[indexPath.row]
            let backItem = UIBarButtonItem()
            backItem.title = subTitle(String(categories?[indexPath.row].title ?? "Back"))
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
    }
    
    func load() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func subTitle(_ title: String) -> String {
        if title.count > 15 {
            return "\(title.prefix(15))..."
        } else {
            return title
        }
    }
}
