//
//  AddBillViewController.swift
//  Project-2
//
//  Created by User on 2019/4/3.
//  Copyright © 2019 Miles. All rights reserved.
//

import UIKit
import Firebase

class AddBillViewController: BaseViewController {
    
    @IBOutlet weak var accountObject: UITextField!
    
    @IBOutlet weak var friendBillName: UITextField!
    
    @IBOutlet weak var billAmount: UITextField!
    
    var dataBase: Firestore = Firestore.firestore()

    var friendID: String?
    
    var friend: [String: Any]?
    
    var friendBillData: [String: Any]?
    
    var friendList: [PersonalData] = []
    
    var newFriendLists = [PersonalData]()
    
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        
        pickerView.dataSource = self
        
        accountObject.inputView = pickerView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        accountObject.text = ""
        
        friendBillName.text = ""
        
        billAmount.text = ""
        
        readFirendList()
        
    }
    
    @objc func closeKeyboard() {
        
        self.view.endEditing(true)
    }
    
    @IBAction func expenseDetail(_ sender: UIButton) {
        
        if accountObject.text?.isEmpty == true
            || friendBillName.text?.isEmpty == true
            || billAmount.text?.isEmpty == true {
            
            AlertManager().alertView(title: "錯誤", message: "請輸入帳單資訊", view: self)
            
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
                        
                    guard error == nil else { return }
                        
                    if querySnapshot?.isEmpty == true {
                            
                        AlertManager().alertView(title: "錯誤", message: "無此帳號", view: self)
                            
                    } else {
                            
                        for document in querySnapshot!.documents {
                            
                            self.friendID = String(document.documentID)
                                
                            self.friend = document.data()
                        }
                            
                        self.dataBase.collection("users")
                            .document(self.friendID ?? "")
                            .collection("friends")
                            .document(currentUser.uid)
                            .getDocument(completion: { (document, _) in
                            
                            self.friendBillData = document?.data()
                                
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
                                
                            splitBillDetailVC.individualCalculationResult = Int(-0.9501)
                                
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
    
    func readFirendList() {
        
        FirebaseManager.shared.readFriendListData { [weak self] (friendList) in
            self?.friendList = friendList
            
            self?.list()
        }
    }
    
    func list() {
        
        var tempFriendList: [PersonalData] = []
        
        for lists in 0..<friendList.count {
            
            guard let newFriendList = friendList[lists].status else { return }
            
            if newFriendList == 1 {
                
                tempFriendList.append(friendList[lists])
                
            }
            
            newFriendLists = tempFriendList

        }
    }
}

extension AddBillViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return newFriendLists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return newFriendLists[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if newFriendLists.count == 0 {
        } else {
            accountObject.text = newFriendLists[row].name
        }
    }
}
