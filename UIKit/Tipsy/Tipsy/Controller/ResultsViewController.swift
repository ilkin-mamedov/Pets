//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Ilkin Mamedov on 09.03.2022.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var result: String?
    var numberOfPeople: String?
    var tipPercentage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = result
        settingsLabel.text = "Split between \(numberOfPeople!) people, with \(tipPercentage!) tip."
    }

    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
