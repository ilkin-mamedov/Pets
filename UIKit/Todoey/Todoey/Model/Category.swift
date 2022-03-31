import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let items = List<Item>()
}
