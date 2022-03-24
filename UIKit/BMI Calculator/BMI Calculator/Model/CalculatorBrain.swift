import Foundation
import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    mutating func calculateBMI(weight: Float, height: Float) {
        let bmiValue = weight / pow(height, 2)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, status: "UNDERWEIGHT", color: .systemMint)
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, status: "NORMAL", color: .systemGreen)
        } else if bmiValue < 29.9 {
            bmi = BMI(value: bmiValue, status: "OVERWEIGHT", color: .yellow)
        } else if bmiValue < 34.9 {
            bmi = BMI(value: bmiValue, status: "OBESE", color: .orange)
        } else {
            bmi = BMI(value: bmiValue, status: "EXTREMELY OBESE", color: .red)
        }
    }
    
    func getBMIValue() -> String {
        return String(format: "%.1f", bmi?.value ?? 0.0)
    }
    
    func getBMIStatus() -> String {
        return bmi?.status ?? "UNKNOWN"
    }
    
    func getBMIColor() -> UIColor {
        return bmi?.color ?? .label
    }
}
 
