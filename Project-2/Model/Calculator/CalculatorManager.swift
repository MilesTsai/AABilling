//
//  CalculatorManager.swift
//  Project-2
//
//  Created by User on 2019/5/14.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation

struct Operating {
    var resultValue: Double = 0
    var bindingValue: Double = 0
    var bindingOperate: String = ""
    
    mutating func resulet(_ operate: String, value secondValue: Double) -> String {
        
        if bindingOperate == "" {
//            bindingValue = secondValue
//            bindingOperate = operate
//            resultValue = secondValue
            calculatorStatus(secondValue: secondValue, operate: operate)
        } else {
            switch bindingOperate {
            case "+": resultValue = bindingValue + secondValue
            case "-": resultValue = bindingValue - secondValue
            case "×": resultValue = bindingValue * secondValue
            case "÷": resultValue = bindingValue / secondValue
            default : break
            }
            bindingValue = resultValue
            bindingOperate = operate
        }
        
        if operate == "=" {
            bindingOperate = ""
        }
        
        return String(resultValue)
    }
    
    mutating func calculatorStatus(secondValue: Double, operate: String) {
        
        bindingValue = secondValue
        bindingOperate = operate
        resultValue = secondValue
    }
    
    mutating func resetBind() {
        bindingValue = 0
        bindingOperate = ""
    }
}

//let operate = Operating()
//operate.

class CalculatorManager {
    
    var userIsInTyping: Bool = false
    
    var valueHasTyping: Bool = false
    
    var afterEquals: Bool = false
    
    var calculationValue: String = ""
    
    var operating = Operating()
    
    var calculatedTotal: String = ""
    
    func number(currentTitle: String?) -> String {
        
        if let pressedNum = currentTitle {
            
            isInTypingValue(pressedNum: pressedNum)
            
            if afterEquals == false {
                
                calculatedTotal += pressedNum
                
            } else {
                
                calculatedTotal = pressedNum
                
                afterEquals = false
                
            }
            valueHasTyping = true
            
            return calculatedTotal
        }
        return ""
    }
    
    func isInTypingValue(pressedNum: String) {
        
        if userIsInTyping == true {
            
            calculationValue += pressedNum
            
        } else {
            
            calculationValue = pressedNum
            
            userIsInTyping = true
        }
    }
    
    func operate(currentTitle: String?) -> String {
    
        if let operate = currentTitle {
            switch operate {
            case "+", "-", "×", "÷":
                if valueHasTyping == true {
                    calculationValue = operating.resulet(operate, value: Double(calculationValue)! as Double)
                    
                    calculatedTotal.append(operate)
                    
                    userIsInTyping = false
                    valueHasTyping = false
                    
                    return calculatedTotal
                    
                } else {
                    
                    calculatedTotal.append(operate)
                    
                    operating.bindingOperate = operate
                    
                    return calculatedTotal
                }
                
            case "=":
                
                return equal()
                
            case "AC":
                
                calculatedTotal = ""
                operating.resetBind()
                userIsInTyping = false
                valueHasTyping = false
                
                return calculatedTotal
                
            default: break
            }
        }
        return ""
    }
    
    func equal() -> String {
            
        afterEquals = true
        
        calculationValue = operating.resulet("=", value: Double(calculationValue)! as Double)
            
        calculatedTotal = calculationValue
        
        return calculatedTotal
    }
}
