import Foundation

struct QuizBrain {
    let quiz = [
        Question(question: "Which is the largest organ in the human body?", answers: ["Heart", "Skin", "Large Intestine"], correctAnswer: "Skin"),
        Question(question: "Five dollars is worth how many nickels?", answers: ["25", "50", "100"], correctAnswer: "100"),
        Question(question: "What do the letters in the GMT time zone stand for?", answers: ["Global Meridian Time", "Greenwich Mean Time", "General Median Time"], correctAnswer: "Greenwich Mean Time"),
        Question(question: "What is the French word for 'hat'?", answers: ["Chapeau", "Écharpe", "Bonnet"], correctAnswer: "Chapeau"),
        Question(question: "In past times, what would a gentleman keep in his fob pocket?", answers: ["Notebook", "Handkerchief", "Watch"], correctAnswer: "Watch"),
        Question(question: "How would one say goodbye in Spanish?", answers: ["Au Revoir", "Adiós", "Salir"], correctAnswer: "Adiós"),
        Question(question: "Which of these colours is NOT featured in the logo for Google?", answers: ["Green", "Orange", "Blue"], correctAnswer: "Orange"),
        Question(question: "What alcoholic drink is made from molasses?", answers: ["Rum", "Whisky", "Gin"], correctAnswer: "Rum"),
        Question(question: "What type of animal was Harambe?", answers: ["Panda", "Gorilla", "Crocodile"], correctAnswer: "Gorilla"),
        Question(question: "Where is Tasmania located?", answers: ["Indonesia", "Australia", "Scotland"], correctAnswer: "Australia")
    ]
    
    var questionNumber = 0
    var score = 0
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool{
        if userAnswer == quiz[questionNumber].correctAnswer {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    mutating func nextQuestion() {
        if questionNumber < (quiz.count - 1) {
            questionNumber += 1
        } else {
            questionNumber = 0
            score = 0
        }
    }
    
    func getProgress() -> Float {
        return Float(questionNumber) / Float(quiz.count - 1)
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getQuestion() -> String {
        return quiz[questionNumber].question
    }
    
    func getAnswers() -> [String] {
        return quiz[questionNumber].answers
    }
}
