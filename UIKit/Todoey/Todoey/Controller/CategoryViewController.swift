import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        
        loadData()
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
                let category = Category(context: self.context)
                category.title = title
                
                self.categories.append(category)
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
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.title
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
            deleteAllItemsByCategory(categories[indexPath.row])
            context.delete(categories[indexPath.row])
            updateData()
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categories[indexPath.row]
            let backItem = UIBarButtonItem()
            backItem.title = subTitle(String(categories[indexPath.row].title!))
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    func updateData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func loadData(_ request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func deleteAllItemsByCategory(_ category: Category) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "category.title MATCHES[cd] %@", category.title!)
        do {
            var items = try context.fetch(request)
            for item in items {
                context.delete(item)
            }
            updateData()
            items.removeAll()
        } catch {
            print(error)
        }
    }
    
    func subTitle(_ title: String) -> String {
        if title.count > 15 {
            return "\(title.prefix(15))..."
        } else {
            return title
        }
    }
}
