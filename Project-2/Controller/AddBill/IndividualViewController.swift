//
//  IndividualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManager

class IndividualViewController: BaseTableViewController {
    
    var individualBilling: BillingContent?
    
    var dataBase: Firestore = Firestore.firestore()
    
    var userNameInfo: String = ""
    
    var userTextField: UITextField?
    
    var friendTextField: UITextField?
    
    var selectHandler: ((String) -> Void)?
    
    var owedAmount: ((Int) -> Void)?
    
    var payAmount: ((Int?) -> Void)?
    
    var friendOwedAmount: ((Int) -> Void)?
    
    var friendPayAmount: ((Int) -> Void)?
    
    var selectTextField: Bool?
    
    @IBOutlet weak var numberKeyView: UIView!
    
    @IBOutlet weak var calculatedTotal: UILabel!
    
    var userIsInTyping: Bool = false
    
    var valueHasTyping: Bool = false
    
    var afterEquals: Bool = false
    
    var calculationValue: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        guard let currentUser = Auth.auth().currentUser
            else {
                return
        }
        
        dataBase
            .collection("users")
            .document(currentUser.uid)
            .getDocument { [weak self](snapshot, _) in
                
            guard let document = snapshot?.data()
                else {
                    return
                }
                
            self?.userNameInfo = document["name"] as? String ?? "No Document"
            print(self?.userNameInfo ?? "")
            self?.tableView.reloadData()
        }
        
        setupTableView()
        
        view.bringSubviewToFront(numberKeyView)
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor.white
        
        tableView.mls_registerCellWithNib(
            identifier: String(describing: IndividualCell.self),
            bundle: nil
        )
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
        -> Int {
            
        return 2
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            let myCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: IndividualCell.self),
                for: indexPath
            )
            
            guard let individualCell = myCell as? IndividualCell
                else {
                    return myCell
            }
            
            individualCell.amountTextField.inputView = UIView(frame: CGRect.zero)
            
            individualCell.amountTextField.delegate = self
            
            individualCell.userName.text = userNameInfo
            
            userTextField = individualCell.amountTextField
            
            individualCell.amountTextField.addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
            
            return individualCell
            
        case 1:
            let friendCell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: IndividualCell.self),
                for: indexPath
            )
            
            guard let individualCell =
                friendCell as? IndividualCell
                else {
                    return friendCell
            }
            
            individualCell.amountTextField.inputView = UIView(frame: CGRect.zero)
            
            individualCell.amountTextField.delegate = self
            
            individualCell.userName.text = individualBilling?.anyone
            
            friendTextField = individualCell.amountTextField
            
            individualCell.amountTextField.addTarget(
                self,
                action: #selector(textFieldDidChange(_:)),
                for: .editingChanged
            )
            
            return individualCell
        
        default:
            
            return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            
        return 60
    }
    
//    func tableView(
//        _ tableView: UITableView,
//        didSelectRowAt indexPath: IndexPath) {
//        
//        if indexPath.row == 0 {
//            selectHandler?(userNameInfo)
//        } else if indexPath.row == 1 {
//            selectHandler?(individualBilling!.anyone)
//        } else {
//            return
//        }
//    }
    
//    func numberPressed(_ number: String) {
//        calculatedTotal.text?.append(number)
//    }
    
    @IBAction func numbers(_ sender: UIButton) {
        
        if let pressedNum = sender.currentTitle {
            if userIsInTyping == true {
                calculationValue += pressedNum
                
            } else {
                calculationValue = pressedNum
                
                userIsInTyping = true
            }
            
            if afterEquals == false {
                
                calculatedTotal.text = calculatedTotal.text! + pressedNum
            } else {
                calculatedTotal.text = pressedNum
            }
            valueHasTyping = true
        }
    }
    
//    var displayValue: Double {
//        get {
//            if calculatedTotal != nil {
//                return Double(calculatedTotal.text!)!
//            } else {
//                return 0
//            }
//        }
//        set {
//            if round(newValue) == newValue {
//                calculatedTotal.text = String(Int(newValue))
//            } else {
//                calculatedTotal.text = String(newValue)
//            }
//        }
//    }
    
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
            
            return String(Int(resultValue))
        }
        
        mutating func resetBind() {
            bindingValue = 0
            bindingOperate = ""
        }
    }
    
    var operating = Operating()
    
    @IBAction func operate(_ sender: UIButton) {
        if let operate = sender.currentTitle {
            switch operate {
            case "+", "-", "×", "÷", "=":
                if valueHasTyping == true {
                    calculationValue = operating.resulet(operate, value: Double(calculationValue)! as Double)
                    if operate != "=" {
                        calculatedTotal.text?.append(operate)
                    }
                    userIsInTyping = false
                    valueHasTyping = false
                    
                    if operate == "=" {
                        
                        afterEquals = false
                        
                        calculatedTotal.text = calculationValue
                        
                        guard let value = Int(calculationValue) else { return }

                        if selectTextField == true {

                            userTextField?.text = "\(value)"
                            guard let userAmount = Int(userTextField?.text ?? "") else { return }

                            friendTextField?.text = "\(individualBilling!.amount - userAmount)"
                            textFieldDidChange(userTextField!)

                        } else {

                            friendTextField?.text = "\(value)"

                            guard let friendAmount = Int(friendTextField?.text ?? "") else { return }

                            userTextField?.text = "\(individualBilling!.amount - friendAmount)"
                            textFieldDidChange(friendTextField!)
                        }
                    }
                    
                } else {
                    if operate != "=" {
                        calculatedTotal.text?.append(operate)
                    }
                    operating.bindingOperate = operate
                }
                
            case "AC":
                calculatedTotal.text = ""
                userTextField?.text = calculatedTotal.text
                friendTextField?.text = calculatedTotal.text
                operating.resetBind()
                userIsInTyping = false
                valueHasTyping = false
                
            default: break
            }
        }
    }
}

extension IndividualViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userTextField {
            selectTextField = true
        } else {
            selectTextField = false
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == userTextField {
            
            if userTextField?.text == "" {
                
                friendTextField?.text = ""
                
                owedAmount?(Int(-0.9501))
                
            } else {
                
                guard let userAmount = Int(userTextField?.text ?? "")
                    else {
                        
                        payAmount?(nil)
                        
                        return
                }
                friendTextField?.text =
                "\(individualBilling!.amount - userAmount)"
                
                payAmount?(userAmount)
                
                owedAmount?(userAmount - individualBilling!.amount / 2)
                
                friendPayAmount?(individualBilling!.amount - userAmount)
                
                friendOwedAmount?(individualBilling!.amount / 2 - userAmount)
            }
            
        } else {

            if friendTextField?.text == "" {

                userTextField?.text = ""

            } else {

                guard let friendAmount = Int(friendTextField?.text ?? "")
                    else {
                        return
                }
                userTextField?.text =
                "\(individualBilling!.amount - friendAmount)"

                payAmount?(individualBilling!.amount - friendAmount)
                
                owedAmount?(individualBilling!.amount - friendAmount - individualBilling!.amount / 2)
                
                friendPayAmount?(friendAmount)
                
                friendOwedAmount?(friendAmount - individualBilling!.amount / 2)
            }
        }
    }
}
