import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            load()
        }
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
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)

        alert.view.tintColor = UIColor(named: "AlertColor")
        
        alert.addTextField { textField in textField.placeholder = "Enter a title of your item" }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { action in
            if let title = alert.textFields![0].text,
                let currentCategory = self.selectedCategory,
                !title.isEmpty {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = title
                        currentCategory.items.append(item)
                    }
                } catch {
                    print(error)
                }
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
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = UIColor(named: "TextColor")!
            
            let backgroundViewCell = UIView()
            backgroundViewCell.backgroundColor = UIColor(named: "CellColor")!
            cell.selectedBackgroundView = backgroundViewCell
            
            switcher(cell: cell, done: item.done)
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    switcher(cell: tableView.cellForRow(at: indexPath)!, done: item.done)
                }
            } catch {
                print(error)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = items?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    print(error)
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func switcher(cell: UITableViewCell, done: Bool) {
        cell.accessoryType = done ? .checkmark : .none
    }
    
    func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//extension ItemViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadData(with: request, predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadData()
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
