import Foundation

class CalculatorManager {
    
    var number: Double
    
    init(number: Double) {
        self.number = number
    }
    
    func calculate(method: String) -> Double? {
        switch method {
            case "AC":
                return 0
            case "+/-":
                return number * -1
            case "%":
                return number / 100
            default:
                return nil
        }
    }
}
