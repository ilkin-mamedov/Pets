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
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
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
                        item.dateCreated = Date.now
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            cell.textLabel?.textColor = UIColor(named: "TextColor")!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm MMM d, yyyy "
            cell.detailTextLabel?.text = dateFormatter.string(from: item.dateCreated!)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.detailTextLabel?.textColor = UIColor(named: "TextColor")!
            
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
            -> UISwipeActionsConfiguration? {
            let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                if let item = self.items?[indexPath.row] {
                    let alert = UIAlertController(title: "Do you really want to delete '\(item.title)' item?", message: "If you delete it, you will no longer be able to recover it.", preferredStyle: .alert)

                    alert.view.tintColor = UIColor(named: "AlertColor")

                    let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }

                    let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
                        do {
                            try self.realm.write {
                                self.realm.delete(item)
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
    
    func switcher(cell: UITableViewCell, done: Bool) {
        cell.accessoryType = done ? .checkmark : .none
    }
    
    func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
}

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
