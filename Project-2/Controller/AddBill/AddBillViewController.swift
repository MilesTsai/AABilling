//
//  AddBillViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

struct BillingContent {
    
    let anyone: String
    
    let billName: String
    
    let amount: Int
}

class AddBillViewController: BaseViewController {
    
    @IBOutlet weak var accountObject: UITextField!
    
    @IBOutlet weak var friendBillName: UITextField!
    
    @IBOutlet weak var billAmount: UITextField!
    
    var dataBase: Firestore = Firestore.firestore()

    var friendID: String?
    
    var friend: [String: Any]?
    
    var friendBillData: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        accountObject.text = ""
        
        friendBillName.text = ""
        
        billAmount.text = ""
    }
    
    @IBAction func expenseDetail(_ sender: UIButton) {
        
        if accountObject.text?.isEmpty == true
            || friendBillName.text?.isEmpty == true
            || billAmount.text?.isEmpty == true {
            
            let alertController =
                UIAlertController(
                    title: "錯誤",
                    message: "請輸入帳單資訊",
                    preferredStyle: .alert
            )
            let defaultAction =
                UIAlertAction(
                    title: "OK",
                    style: .cancel,
                    handler: nil
            )
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            guard let currentUser = Auth.auth().currentUser
                else {
                    return
            }
            
            dataBase
                .collection("users")
                .document(currentUser.uid)
                .collection("friends")
                .whereField("name", isEqualTo: accountObject.text ?? "")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        if querySnapshot?.isEmpty == true {
                            print("No exist")
                            let alertController =
                                UIAlertController(
                                    title: "錯誤",
                                    message: "無此帳號",
                                    preferredStyle: .alert
                            )
                            
                            let defaultAction =
                                UIAlertAction(
                                    title: "OK",
                                    style: .cancel,
                                    handler: nil
                            )
                            
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                
                                self.friendID = String(document.documentID)
                                
                                self.friend = document.data()
                            }
                            
                            self.dataBase.collection("users").document(self.friendID ?? "").collection("friends").document(currentUser.uid).getDocument(completion: { (document, error) in
                                
                                self.friendBillData = document?.data()
                                print(document?.data())
                                
                                let storyboard = UIStoryboard(name: "Friend", bundle: nil)
                                
                                guard let expenseVC =
                                    storyboard.instantiateViewController(
                                        withIdentifier: String(describing: "ExpenseDetail")
                                        ) as? UINavigationController
                                    else {
                                        return
                                }
                                
                                guard let splitBillDetailVC =
                                    expenseVC.topViewController as? SplitBillDetailViewController
                                    else {
                                        return
                                }
                                
                                guard let amount = Int(self.billAmount.text ?? "")
                                    else {
                                        return
                                }
                                
                                splitBillDetailVC.billingContent = BillingContent(
                                    anyone: self.accountObject.text ?? "",
                                    billName: self.friendBillName.text ?? "",
                                    amount: amount
                                )
                                
                                splitBillDetailVC.equalResult = amount / 2
                                
                                splitBillDetailVC.equalCalculationResult = 0
                                
                                splitBillDetailVC.individualCalculationResult = Int(-0.01)
                                
                                splitBillDetailVC.friendEqualCalculationResult = 0
                                
                                splitBillDetailVC.friendEqualResult = amount / 2
                                
                                splitBillDetailVC.friendID = self.friendID
                                
                                splitBillDetailVC.myFriend = self.friend
                                
                                splitBillDetailVC.friendBillData = self.friendBillData
                                
                                self.present(expenseVC, animated: true, completion: nil)
                            })
                        }
                    }
            }
        }
    }
}
