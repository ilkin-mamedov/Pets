import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var statusBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        let appearance = UINavigationBarAppearance();
        appearance.backgroundColor = UIColor(named: "BarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        if let savedItems = userDefaults.data(forKey: "toDoItems") {
            do {
                items = try JSONDecoder().decode([Item].self, from: savedItems)
                items.sort(by: { $0.id > $1.id })
                updateStatus()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)

        alert.view.tintColor = UIColor(named: "AlertColor")
        
        alert.addTextField { textField in
            textField.placeholder = "Enter a title of your item"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { action in
            let id = self.items.count + 1
            let title = alert.textFields![0].text!
            
            if !title.isEmpty {
                self.items.append(Item(id: id, title: title, isDone: false))
                do {
                    let data = try JSONEncoder().encode(self.items)
                    self.userDefaults.set(data, forKey: "toDoItems")
                } catch {
                    print(error)
                }
            }
            
            self.updateStatus()
            self.tableView.reloadData()
        }
        
        alert.addAction(cancel)
        alert.addAction(add)
        
        present(alert, animated: true, completion: {
            alert.view.tintColor = UIColor(named: "AlertColor")
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = UIColor(named: "TextColor")!
        
        let backgroundViewCell = UIView()
        backgroundViewCell.backgroundColor = UIColor(named: "CellColor")!
        cell.selectedBackgroundView = backgroundViewCell
        
        switcher(cell: cell, isDone: item.isDone)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isDone = !item.isDone
        
        do {
            switcher(cell: tableView.cellForRow(at: indexPath)!, isDone: item.isDone)
            
            let data = try JSONEncoder().encode(self.items)
            self.userDefaults.set(data, forKey: "toDoItems")
            self.updateStatus()
        } catch {
            print(error)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func switcher(cell: UITableViewCell, isDone: Bool) {
        if isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func updateStatus() {
        var done = 0
        var notDone = 0
        
        for item in items {
            if item.isDone {
                done += 1
            } else {
                notDone += 1
            }
        }
        statusBar.title = "\(notDone) / \(done) / \(items.count)"
    }
    
}
