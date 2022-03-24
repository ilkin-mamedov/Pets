import UIKit

class CalculateViewController: UIViewController {

    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var calculatorBrain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func heightHasChanged(_ sender: UISlider) {
        heightLabel.text = String(format: "%.2fM", sender.value)
    }
    
    @IBAction func weightHasChanged(_ sender: UISlider) {
        weightLabel.text = String(format: "%.fKG", sender.value)
    }
    
    @IBAction func calculatePressed(_ sender: Any) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        calculatorBrain.calculateBMI(weight: weight, height: height)
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let resultVC = segue.destination as! ResultViewController
            resultVC.bmiValue = calculatorBrain.getBMIValue()
            resultVC.bmiStatus = calculatorBrain.getBMIStatus()
            resultVC.bmiColor = calculatorBrain.getBMIColor()
        }
    }
}
