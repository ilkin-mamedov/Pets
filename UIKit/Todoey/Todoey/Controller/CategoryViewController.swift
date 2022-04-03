import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

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
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { action in
            if let title = alert.textFields![0].text, !title.isEmpty {
                let category = Category()
                category.title = title
                category.dateCreated = Date.now
                
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cell.textLabel?.textColor = UIColor(named: "TextColor")!
        
        cell.detailTextLabel?.text = "\(category?.items.count ?? 0) items"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.detailTextLabel?.textColor = .systemGray
        
        let backgroundViewCell = UIView()
        backgroundViewCell.backgroundColor = UIColor(named: "CellColor")!
        cell.selectedBackgroundView = backgroundViewCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                if let category = self.categories?[indexPath.row] {
                    let alert = UIAlertController(title: "Do you really want to delete '\(category.title!)' category?", message: "If you delete it, you will no longer be able to recover it.", preferredStyle: .alert)

                    alert.view.tintColor = UIColor(named: "AlertColor")
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
                        do {
                            try self.realm.write {
                                self.realm.delete(category.items)
                                self.realm.delete(category)
                            }
                        } catch {
                            print(error)
                        }
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                    alert.addAction(cancel)
                    alert.addAction(delete)
                    
                    self.present(alert, animated: true, completion: {
                        alert.view.tintColor = UIColor(named: "AlertColor")
                    })
                }
                completionHandler(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            return configuration
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
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: false)
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
