import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var firstChoiceButton: UIButton!
    @IBOutlet weak var secondChoiceButton: UIButton!
    
    var storyBrain = StoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(story: storyBrain.stories[storyBrain.storyNumber])
    }

    @IBAction func choiceMade(_ sender: UIButton) {
        let userChoice = sender.currentTitle!
        
        storyBrain.nextStory(userChoice: userChoice)
        
        updateUI(story: storyBrain.stories[storyBrain.storyNumber])
    }
    
    func updateUI(story: Story) {
        storyLabel.text = story.title
        firstChoiceButton.setTitle(story.choice1, for: .normal)
        secondChoiceButton.setTitle(story.choice2, for: .normal)
    }
}
