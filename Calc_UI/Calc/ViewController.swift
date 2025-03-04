//
//  ViewController.swift
//  Calc
//
//  Created by Артём on 29.11.2024.
//

import UIKit

class ViewController: UIViewController {
    var currentText = "0"
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        expressionLabel.isHidden = true
        super.viewDidLoad()
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        resultLabel.text = ""
        
        switch sender.tag {
        case 0:
            if currentText != "0" && currentText.count <= 12 {
                let components = currentText.components(separatedBy: CharacterSet(charactersIn: "+-*/"))
                let lastComponent = components.last ?? ""
                if !lastComponent.isEmpty {
                    if !lastComponent.contains(".") && lastComponent != "0" {
                        currentText += "0"
                    } else if lastComponent.contains(".") {
                        currentText += "0"
                    }
                } else {
                    currentText += "0"
                }
            }
        case 1: currentText = currentText == "0" ? "1" : currentText + "1"
        case 2: currentText = currentText == "0" ? "2" : currentText + "2"
        case 3: currentText = currentText == "0" ? "3" : currentText + "3"
        case 4: currentText = currentText == "0" ? "4" : currentText + "4"
        case 5: currentText = currentText == "0" ? "5" : currentText + "5"
        case 6: currentText = currentText == "0" ? "6" : currentText + "6"
        case 7: currentText = currentText == "0" ? "7" : currentText + "7"
        case 8: currentText = currentText == "0" ? "8" : currentText + "8"
        case 9: currentText = currentText == "0" ? "9" : currentText + "9"
        case 10:
            if let lastCharacter = currentText.last, "+-*/".contains(lastCharacter) == false {
                currentText += "+"
            }
        case 11:
            if let lastCharacter = currentText.last, "+-*/".contains(lastCharacter) == false {
                currentText += "-"
            }
        case 12:
            if let lastCharacter = currentText.last, "+-*/".contains(lastCharacter) == false {
                currentText += "*"
            }
        case 13:
            if let lastCharacter = currentText.last, "+-*/".contains(lastCharacter) == false {
                currentText += "/"
            }
        case 14:
            if let finalResult = calculateResult(currentText: currentText) {
                expressionLabel.isHidden = false
                expressionLabel.text = currentText
                print(finalResult)
                currentText = "\(finalResult)"
            } else {
                print("Error")
            }
        case 15: 
            currentText = "0"
            expressionLabel.text = ""
            expressionLabel.isHidden = true
        case 16:
            let components = currentText.components(separatedBy: CharacterSet(charactersIn: "+-*/"))
            let lastComponent = components.last ?? ""
            if !lastComponent.contains(".") && !currentText.isEmpty {
                currentText += "."
            }
        case 17:
            if currentText.hasPrefix("–") || currentText.hasPrefix("-") {
                currentText.removeFirst()
            } else if let lastCharacter = currentText.last,
               ("0123456789".contains(lastCharacter)), currentText != "0" {
                currentText = "–\(currentText)"
            }
        case 18:
            var components = currentText.components(separatedBy: CharacterSet(charactersIn: "+-*/"))
            
            if components[0].contains("–") {
                components[0].removeFirst()
            }

            guard let firstComponent = components.first, let firstNumber = Float(firstComponent) else {
                break
            }
            print("firstNumber: \(firstNumber)")
                            
            guard let lastComponent = components.last, let lastNumber = Float(lastComponent) else {
                break
            }
            print("lastNumber: \(lastNumber)")
            
            if currentText.contains("+") || currentText.contains("-") {
                let percentageValue = (firstNumber * lastNumber) / 100
                print("percentageValue: \(percentageValue)")
                currentText = currentText.replacingOccurrences(of: lastComponent, with: "\(percentageValue)")
            } else {
                let percentageValue = lastNumber / 100
                print("percentageValue: \(percentageValue)")
                currentText = currentText.replacingOccurrences(of: lastComponent, with: "\(percentageValue)")
            }
        case -1:
            if !currentText.isEmpty {
                currentText.removeLast()
                if currentText.count <= 9 {
                    resultLabel.font = UIFont.boldSystemFont(ofSize: 60)
                }
            }
        case -2: fallthrough
        default: break
        }
        
        if currentText.count > 12 {
            let alert = UIAlertController(title: "Warning!", message: """
                                          You have entered too many characters
                                          The result will not fit on the screen
                                          Reduce the current value or reset it
                                          """, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
        
        if currentText.count > 9 {
            resultLabel.font = UIFont.boldSystemFont(ofSize: 50)
        } else {
            resultLabel.font = UIFont.boldSystemFont(ofSize: 60)
        }
        
        resultLabel.text = currentText
    }
    
    func separateNumbersAndOperators(currentText: String) -> (numbers: [String], operators: [String]) {
        print(currentText)
        
        var numbers: [String] = []
        var operators: [String] = []
        //another dash is added to the beginning of the pattern to separate just a negative number and a minus sign between numbers
        let pattern = "(–?[0-9]+(?:\\.[0-9]+)?|[+*/-])"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsString = currentText as NSString
            let results = regex.matches(in: currentText, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in results {
                let matchedString = nsString.substring(with: match.range)

                if matchedString.hasPrefix("–") {
                    numbers.append(matchedString)
                }
                if let _ = Float(matchedString) {
                    numbers.append(matchedString)
                } else if !matchedString.hasPrefix("–") {
                    operators.append(matchedString)
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return (numbers, operators)
    }
    
    func calculateResult(currentText: String) -> String? {
        let (numbers, operators) = separateNumbersAndOperators(currentText: currentText)
        print("Numbers: \(numbers)")
        print("Operators: \(operators)")
        
        let formattedNumbers = numbers.map { number -> String in
            if number.hasPrefix("–") {
                return String(number.dropFirst())
            }
            return number
        }

        guard let newNumbers = formattedNumbers.map({ Float($0) }) as? [Float] else { return nil }
        
        guard newNumbers.count == operators.count + 1 else { return nil }
        
        var result = newNumbers[0]
        
        for i in 0..<operators.count {
            let operatorSymbol = operators[i]
            let nextNumber = newNumbers[i + 1]
            
            switch operatorSymbol {
            case "+":
                if numbers[0].hasPrefix("–") {
                    if result < nextNumber {
                        result = nextNumber - result
                    } else if result > nextNumber {
                        result = (result - nextNumber) * -1
                    } else {
                        result = 0
                    }
                } else {
                    result += nextNumber
                }
            case "-":
                if numbers[0].hasPrefix("–") {
                    result = (nextNumber + result) * -1
                } else {
                    result -= nextNumber
                }
            case "*":
                if numbers[0].hasPrefix("–") {
                    result = (result * nextNumber) * -1
                } else {
                    result *= nextNumber
                }
            case "/":
                if nextNumber != 0 {
                    if numbers[0].hasPrefix("–") {
                        result = (result / nextNumber) * -1
                    } else {
                        result /= nextNumber
                    }
                } else {
                    divideByZeroAlert()
                    return nil
                }
            default:
                return nil
            }
        }
        return String(format: "%g", result)
    }
    
    func divideByZeroAlert() {
        let alert = UIAlertController(title: "Error!", message: "Division by zero is prohibited", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
