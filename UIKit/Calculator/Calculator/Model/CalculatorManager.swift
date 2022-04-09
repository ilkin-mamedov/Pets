import Foundation

struct CalculatorManager {
    
    private var number: Double?
    private var last: (number: Double, method: String)?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculate(method: String) -> Double? {
        if let safeNumber = number {
            switch method {
                case "AC":
                    last = (number: 0.0, method: "")
                    return 0
                case "+/-":
                    return safeNumber * -1
                case "%":
                    return safeNumber / 100
                case "=":
                    return perform(safeNumber)
                default:
                    last = (number: perform(safeNumber)!, method: method)
                    return perform(safeNumber)
            }
        } else {
            return nil
        }
    }
    
    private func perform(_ number: Double) -> Double? {
        if let safeNumber = last?.number,
           let safeMethod = last?.method {
            switch safeMethod {
                case "÷":
                    return safeNumber / number
                case "×":
                    return safeNumber * number
                case "-":
                    return safeNumber - number
                case "+":
                    return safeNumber + number
                default:
                    return 0
            }
        } else {
            return 0
        }
    }
}
