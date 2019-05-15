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
    
    var userData: UserData?
    
    var userTextField: UITextField?
    
    var friendTextField: UITextField?
    
    var selectHandler: ((String) -> Void)?
    
    var owedAmount: ((Int) -> Void)?
    
    var payAmount: ((Int?) -> Void)?
    
    var friendOwedAmount: ((Int) -> Void)?
    
    var friendPayAmount: ((Int) -> Void)?
    
    var calculatorManager = CalculatorManager()
    
    var selectTextField: Bool?
    
    @IBOutlet weak var numberKeyView: UIView!
    
    @IBOutlet weak var calculatedTotal: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        setupTableView()
        
        view.bringSubviewToFront(numberKeyView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    func fetchData() {
        
        FirebaseManager.shared.readUserData { [weak self] (userData) in
            
            self?.userData = userData
            
            self?.userNameInfo = self?.userData?.name ?? ""
            
            self?.tableView.reloadData()
        }
        
    }
    
    private func setupTableView() {
        
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor(cgColor: #colorLiteral(red: 0.9803921569, green: 0.9568627451, blue: 0.8823529412, alpha: 1))
        
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
            
            guard let individualCell = myCell as? IndividualCell else {
                
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
    
    @IBAction func numbers(_ sender: UIButton) {
        
        calculatedTotal.text =  calculatorManager.number(currentTitle: sender.currentTitle)
        
    }

    @IBAction func operate(_ sender: UIButton) {
        
        let totalValue = calculatorManager.operate(currentTitle: sender.currentTitle)
        
        calculatedTotal.text = totalValue
        
        if totalValue == "" {
            
            userTextField?.text = ""
            
            friendTextField?.text = ""
            
        } else {
            
            guard let value = Double(totalValue) else { return }
            
            let newValue = Int(value)
            
            if selectTextField == true {
                
                userTextField?.text = "\(newValue)"
                guard let userAmount = Int(userTextField?.text ?? "") else { return }
                
                friendTextField?.text = "\(individualBilling!.amount - userAmount)"
                textFieldDidChange(userTextField!)
                
            } else {
                
                friendTextField?.text = "\(newValue)"
                
                guard let friendAmount = Int(friendTextField?.text ?? "") else { return }
                
                userTextField?.text = "\(individualBilling!.amount - friendAmount)"
                textFieldDidChange(friendTextField!)
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
