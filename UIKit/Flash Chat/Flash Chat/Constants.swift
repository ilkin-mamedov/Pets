import Foundation

struct K {
    static let appName = "Welcome to Flash Chat!"
    static let welcomeToChat = "welcomeToChat"
    static let signUpToChat = "signUpToChat"
    static let signInToChat = "signInToChat"
    static let chatCell = "chatCell"
    static let messageCell = "MessageCell"
    
    struct Color {
        static let orangeColor = "OrangeColor"
        static let darkColor = "DarkColor"
        static let textColor = "TextColor"
    }
    
    struct Firestore {
        static let collectionName = "messages"
        static let bodyField = "body"
        static let senderField = "sender"
        static let dateField = "date"
    }
}
