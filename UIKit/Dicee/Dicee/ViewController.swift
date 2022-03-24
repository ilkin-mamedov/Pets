import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var diceOne: UIImageView!
    @IBOutlet weak var diceTwo: UIImageView!
    let dice = [#imageLiteral(resourceName: "one"), #imageLiteral(resourceName: "two"), #imageLiteral(resourceName: "three"), #imageLiteral(resourceName: "four"), #imageLiteral(resourceName: "five"), #imageLiteral(resourceName: "six")]
    
    @IBAction func roll(_ sender: Any) {
        diceOne.image = dice.randomElement()
        diceTwo.image = dice.randomElement()
    }
    
}
