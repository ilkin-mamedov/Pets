import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    let eggTimes = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        reset()
        totalTime = eggTimes[sender.currentTitle!]!
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsPassed < self.totalTime {
                self.secondsPassed += 1
                self.titleLabel.text = "\(sender.currentTitle!) Level\n(\(self.secondsPassed) seconds passed)"
                self.progressView.progress = Float(self.secondsPassed) / Float(self.totalTime)
                self.stopButton.isHidden = false
            } else {
                self.timer.invalidate()
                self.titleLabel.text = "Done!"
                self.stopButton.isHidden = true
                self.player = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "alarm_sound", withExtension: "wav")!)
                self.player!.play()
            }
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        reset()
        self.titleLabel.text = "How do you like your eggs?"
    }
    
    func reset() {
        self.timer.invalidate()
        progressView.progress = 0.0
        secondsPassed = 0
    }
    
}
