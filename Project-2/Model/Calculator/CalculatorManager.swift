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
            bindingValue = secondValue
            bindingOperate = operate
            resultValue = secondValue
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
    
    mutating func resetBind() {
        bindingValue = 0
        bindingOperate = ""
    }
}

class CalculatorManager {
    
    var userIsInTyping: Bool = false
    
    var valueHasTyping: Bool = false
    
    var afterEquals: Bool = false
    
    var selectTextField: Bool?
    
    var calculationValue: String = ""
    
    var operating = Operating()
    
    var calculatedTotal: String = ""
    
//    var userTextField: String = ""
//
//    var friendTextField: String = ""
    
    func number(currentTitle: String?) -> String {
        
        if let pressedNum = currentTitle {
            
            if userIsInTyping == true {
                
                calculationValue += pressedNum
                
            } else {
                calculationValue = pressedNum
                
                userIsInTyping = true
            }
            
            if afterEquals == false {
                
                calculatedTotal += pressedNum
                
            } else {
                
                calculatedTotal = pressedNum
                
            }
            valueHasTyping = true
            
            return calculatedTotal
        }
        return ""
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
            
        afterEquals = false
        
        calculationValue = operating.resulet("=", value: Double(calculationValue)! as Double)
            
        calculatedTotal = calculationValue
        
        return calculatedTotal
    }
}
