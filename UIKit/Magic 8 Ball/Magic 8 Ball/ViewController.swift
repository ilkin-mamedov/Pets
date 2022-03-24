import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var answer: UIImageView!
    let answers = [#imageLiteral(resourceName: "yes"), #imageLiteral(resourceName: "no"), #imageLiteral(resourceName: "askagainlater"), #imageLiteral(resourceName: "theanswerisyes"), #imageLiteral(resourceName: "ihavenoidea")]
    
    @IBAction func ask(_ sender: UIButton) {
        answer.image = answers.randomElement()
    }
    
}
