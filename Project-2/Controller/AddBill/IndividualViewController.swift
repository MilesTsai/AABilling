//
//  IndividualViewController.swift
//  Project-2
//
//  Created by User on 2019/4/17.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class IndividualViewController: BaseTableViewController {
    
    var individualBilling: BillingContent?
    
    var dataBase: Firestore = Firestore.firestore()
    
    var userNameInfo: String = ""
    
    var userTextField: UITextField?
    
    var friendTextField: UITextField?
    
    var selectHandler: ((String) -> Void)?
    
    var shareAmount: ((Int) -> Void)?
    
    var payAmount: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            myCell.selectedBackgroundView = backgroundView
            
            guard let individualCell = myCell as? IndividualCell
                else {
                    return myCell
            }
            
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
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            friendCell.selectedBackgroundView = backgroundView
            
            guard let individualCell =
                friendCell as? IndividualCell
                else {
                    return friendCell
            }
            
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
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            selectHandler?(userNameInfo)
        } else if indexPath.row == 1 {
            selectHandler?(individualBilling!.anyone)
        } else {
            return
        }
    }
}

extension IndividualViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == userTextField {
            
            if userTextField?.text == "" {
                
                friendTextField?.text = ""
                
                shareAmount?(individualBilling!.amount - individualBilling!.amount + Int(0.01))
                
            } else {
                
                guard let userAmount = Int(userTextField?.text ?? "")
                    else {
                        return
                }
                friendTextField?.text =
                "\(individualBilling!.amount - userAmount)"
                
                payAmount?(userAmount)
                
                shareAmount?(userAmount - individualBilling!.amount / 2)
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
                
                payAmount?(friendAmount)
                
                shareAmount?(friendAmount - individualBilling!.amount / 2)
            }
        }
    }
}
