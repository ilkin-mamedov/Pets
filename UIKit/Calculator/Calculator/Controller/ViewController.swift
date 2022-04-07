import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    private var isFinishedTypingNumber: Bool = true
    public var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError()
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func calculatePressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        
        if let method = sender.currentTitle {
            let manager = CalculatorManager(number: displayValue)
            guard let result = manager.calculate(method: method) else {
                fatalError()
            }
            displayValue = result
        }
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if let numberValue = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = numberValue
                isFinishedTypingNumber = false
            } else {
                if numberValue == "." {
                    let isInt = floor(displayValue) == displayValue
                    
                    if !isInt {
                        return
                    }
                }
                
                displayLabel.text = displayLabel.text! + numberValue
            }
        }
    }
}
