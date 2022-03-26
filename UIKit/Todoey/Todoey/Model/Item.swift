import Foundation

class Item: Codable {
    var id: Int
    var title: String
    var isDone: Bool
    
    init(id: Int, title: String, isDone: Bool) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}
