import UIKit

class CalculateViewController: UIViewController {

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var result: Float?
    var tip: Float?

    @IBAction func tipChanged(_ sender: UIButton) {
        switch sender.currentTitle! {
            case "0%":
                zeroPctButton.isSelected = true
                tenPctButton.isSelected = false
                twentyPctButton.isSelected = false
            case "10%":
                zeroPctButton.isSelected = false
                tenPctButton.isSelected = true
                twentyPctButton.isSelected = false
            case "20%":
                zeroPctButton.isSelected = false
                tenPctButton.isSelected = false
                twentyPctButton.isSelected = true
            default:
                zeroPctButton.isSelected = false
                tenPctButton.isSelected = true
                twentyPctButton.isSelected = false
        }
        billTextField.endEditing(true)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        splitNumberLabel.text = String(Int(sender.value))
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        if zeroPctButton.isSelected {
            tip = 0.0
        } else if tenPctButton.isSelected {
            tip = 0.1
        } else if twentyPctButton.isSelected {
            tip = 0.2
        } else {
            tip = 0.1
        }
        
        let bill = Float(billTextField.text!) ?? 0.0
        let percent = bill * tip!
        let split = Int(splitNumberLabel.text!)
        result = Float(bill + percent) / Float(split!)
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultsVC = segue.destination as! ResultsViewController
        resultsVC.result = String(format: "%.2f", result!)
        resultsVC.numberOfPeople = splitNumberLabel.text!
        resultsVC.tipPercentage = "\(Int(tip! * 100))%"
    }
}
