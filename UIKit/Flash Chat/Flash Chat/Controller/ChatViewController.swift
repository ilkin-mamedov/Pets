import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var userLabel: UIBarButtonItem!
    
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor(named: K.Color.orangeColor)
        
        if let email = Auth.auth().currentUser?.email {
            userLabel.title = email
        }
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.messageCell, bundle: nil), forCellReuseIdentifier: K.chatCell)
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance();
        appearance.backgroundColor = UIColor(named: K.Color.orangeColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
   }
    
    func loadMessages() {
        db.collection(K.Firestore.collectionName)
            .order(by: K.Firestore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print(e)
            } else {

                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        if let sender = document.data()[K.Firestore.senderField] as? String,
                            let body = document.data()[K.Firestore.bodyField] as? String,
                            var date = document.data()[K.Firestore.dateField] {
                            date = self.getDate(date: date as! TimeInterval)
                            let message = Message(sender: sender, body: body, date: date as! String)
                            self.messages.append(message)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getDate(date: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.YYYY"
        return dateFormatter.string(from: NSDate(timeIntervalSince1970: date) as Date)
    }

    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print(error.localizedDescription)
        } 
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.Firestore.collectionName).addDocument(data: [
                K.Firestore.bodyField : messageBody,
                K.Firestore.senderField : messageSender,
                K.Firestore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print(e)
                } else {
                    DispatchQueue.main.async {
                        self.messageTextField.text = ""
                    }
                }
            }
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.chatCell, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.body
        cell.senderLabel.text = message.sender
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.bubbleView.backgroundColor = UIColor(named: K.Color.orangeColor)
            cell.messageLabel.textColor = .white
            cell.messageLabel.textAlignment = .right
            cell.senderLabel.textAlignment = .right
            cell.senderLabel.text = "You at \(message.date)"
            cell.senderLabel.textColor = UIColor(named: K.Color.orangeColor)
        } else {
            cell.bubbleView.backgroundColor = .white
            cell.messageLabel.textColor = UIColor(named: K.Color.darkColor)
            cell.messageLabel.textAlignment = .left
            cell.senderLabel.textAlignment = .left
            cell.senderLabel.text = "\(message.sender) at \(message.date)"
            cell.senderLabel.textColor = UIColor(named: K.Color.textColor)
        }
        return cell
    }
}
