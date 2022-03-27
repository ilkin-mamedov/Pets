import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [Item]()
    
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    @IBOutlet weak var statusBar: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor(named: "TextColor")!
        
        let appearance = UINavigationBarAppearance();
        appearance.backgroundColor = UIColor(named: "BarColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "TextColor")!]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        loadData()
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)

        alert.view.tintColor = UIColor(named: "AlertColor")
        
        alert.addTextField { textField in textField.placeholder = "Enter a title of your item" }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { action in
            let id = self.items.count + 1
            
            if let title = alert.textFields![0].text, !title.isEmpty {
                self.items.append(Item(id: id, title: title, isDone: false))
                self.updateData()
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
        let cell = tableView.cellForRow(at: indexPath)!
        
        item.isDone = !item.isDone
        
        switcher(cell: cell, isDone: item.isDone)
        updateData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func switcher(cell: UITableViewCell, isDone: Bool) {
        cell.accessoryType = isDone ? .checkmark : .none
    }
    
    func updateData() {
        do {
            let data = try PropertyListEncoder().encode(items)
            try data.write(to: dataPath!)
            items.sort(by: {$0.id > $1.id})
        } catch {
            print(error)
        }
        updateStatus()
    }
    
    func loadData() {
        do {
            if let data = try? Data(contentsOf: dataPath!) {
                items = try PropertyListDecoder().decode([Item].self, from: data)
                items.sort(by: {$0.id > $1.id})
            }
        } catch {
            print(error)
        }
        updateStatus()
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
