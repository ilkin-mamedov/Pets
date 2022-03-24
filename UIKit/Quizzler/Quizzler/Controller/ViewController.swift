import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    var quizBrain = QuizBrain()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = .green
        } else {
            sender.backgroundColor = .red
        }
        
        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        questionLabel.text = quizBrain.getQuestion()
        progressBar.progress = quizBrain.getProgress()
        scoreLabel.text = String(quizBrain.getScore())
        firstButton.setTitle(quizBrain.getAnswers()[0], for: .normal)
        secondButton.setTitle(quizBrain.getAnswers()[1], for: .normal)
        thirdButton.setTitle(quizBrain.getAnswers()[2], for: .normal)
        firstButton.backgroundColor = .black
        secondButton.backgroundColor = .black
        thirdButton.backgroundColor = .black
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "What is your name?", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        let action = UIAlertAction(title: "Continue", style: .default) { [weak alert] _ in guard let textFields = alert?.textFields else { return }
            
            if let name = textFields[0].text {
                if name != "" {
                    self.nameLabel.text = "\(name.uppercased())'S SCORE:"
                }
            }
        }

        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}
