import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String?
    @objc dynamic var dateCreated: Date?
    let items = List<Item>()
}
