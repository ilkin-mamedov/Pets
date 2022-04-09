import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    private var isFinishedTypingNumber: Bool = true
    
    public var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                return 0
            }
            return number
        }
        set {
            if floor(newValue) == newValue {
                displayLabel.text = String(Int(newValue))
            } else {
                displayLabel.text = String(newValue)
            }
        }
    }
    
    private var manager = CalculatorManager()

    @IBAction func calculatePressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        
        manager.setNumber(displayValue)
        
        if let method = sender.titleLabel?.text {
            if let result = manager.calculate(method: method) {
                displayValue = result
            }
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        if let numberValue = sender.titleLabel?.text {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
