import UIKit
import SwifteriOS
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var positiveLabel: UILabel!
    @IBOutlet weak var negativeLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    
    private let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI",
    consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")
    
    private let emotionClassifier = try! EmotionClassifier(configuration: .init())
    
    private var positive = 0
    private var negative = 0
    private var neutral = 0
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: UIButton) {
        fetchTweets()
    }
    
    private func fetchTweets() {
        if let search = textField.text {
            swifter.searchTweet(using: search, lang: "en", count: 100, tweetMode: .extended) { results, metadata in
                
                var tweets = [EmotionClassifierInput]()
                
                for result in results.array ?? [] {
                    if let tweet = result["full_text"].string {
                        tweets.append(EmotionClassifierInput( text: tweet))
                    }
                }
                
                self.makePrediction(with: tweets)
            } failure: { error in
                print(error)
            }
        }
    }
    
    private func makePrediction(with tweets: [EmotionClassifierInput]) {
        do {
            let predictions = try self.emotionClassifier.predictions(inputs: tweets)
            
            for prediction in predictions {
                switch prediction.label {
                    case "Pos":
                        positive += 1
                        score += 1
                    case "Neg":
                        negative += 1
                        score -= 1
                    case "Neutral":
                        neutral += 1
                    default:
                        break
                }
            }
            
            updateUI()
        } catch {
            print(error)
        }
    }
    
    private func updateUI() {
        if score > 0 {
            self.emotionImage.image = UIImage(named: "Positive")
        } else if score < 0 {
            self.emotionImage.image = UIImage(named: "Negative")
        } else {
            self.emotionImage.image = UIImage(named: "Neutral")
        }
        
        positiveLabel.text = "Positive: \(positive)"
        negativeLabel.text = "Negative: \(negative)"
        neutralLabel.text = "Neutral: \(neutral)"
    }
}
