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
    
    var user: PersonalData?
    
    var bill: BillData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func expenseDetail(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Friend", bundle: nil)
        let expenseVC =
            storyboard.instantiateViewController(
                withIdentifier: String(describing: "ExpenseDetail"))
            present(expenseVC, animated: true, completion: nil)
        
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
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
            dataBase
                .collection("users")
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
                                
                                let friend = document.data()
                                
                                self.bill =
                                    BillData(
                                        name: friend["name"] as? String,
                                        billName: friend["billName"] as? String,
                                        amount: friend["amount"] as? Int,
                                        status: friend["status"] as? Int,
                                        uid: friend["uid"] as? String
                                )
                            }
                            self.addDocument(document: self.friendID ?? "")
                            
                            self.dataBase
                                .collection("users")
                                .document(currentUser.uid)
                                .collection("bills")
                                .addDocument(data:
                                    [
                                        BillData.CodingKeys.status.rawValue:
                                        0,
                                        BillData.CodingKeys.name.rawValue:
                                            self.accountObject.text ?? "",
                                        BillData.CodingKeys.billName.rawValue:
                                            self.friendBillName.text ?? "",
                                        BillData.CodingKeys.amount.rawValue:
                                            self.billAmount.text ?? "",
                                        BillData.CodingKeys.uid.rawValue:
                                            self.friendID ?? ""
                                    ])
                            
                            let alertController =
                                UIAlertController(
                                    title: "成功",
                                    message: "帳單已成立",
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
                        }
                    }
//            dataBase
//                .collection("users")
//                .document(currentUser.uid)
//                .collection("bills")
//                .addDocument(data:
//                    [
//                        BillData.CodingKeys.name.rawValue:
//                            accountObject.text ?? "",
//                        BillData.CodingKeys.billName.rawValue:
//                            friendBillName.text ?? "",
//                        BillData.CodingKeys.amount.rawValue:
//                            Int(billAmount.text ?? "") ?? "",
//                        BillData.CodingKeys.status.rawValue: 0
//                ]) { error in
//                    if let error = error {
//                        print("Error adding document: \(error)")
//                    } else {
//                        let alertController =
//                            UIAlertController(
//                                title: "成功",
//                                message: "帳單已成立",
//                                preferredStyle: .alert
//                            )
//                        
//                        let defaultAction =
//                            UIAlertAction(
//                                title: "OK",
//                                style: .cancel,
//                                handler: nil
//                            )
//                        
//                        alertController.addAction(defaultAction)
//                        
//                        self.present(alertController, animated: true, completion: nil)
//                        
//                        self.dataBase.collection("users").addSnapshotListener({ (snapshot, _) in
//                            
//                        guard let snapshot = snapshot else { return }
//                            
//                        for document in snapshot.documents {
//                                print("\(document.documentID) => \(document.data())")
//                            
//                            self.friendID = String(document.documentID)
//                            }
//                        })
//                    }
//                    self.addDocument(document: self.friendID ?? "")
            }
        }
    }
    
    private func addDocument(document: String) {
//        friendID = Friend.friendList[0].uid
        guard let currentUser = Auth.auth().currentUser else { return }
        
        dataBase
            .collection("users")
            .document(friendID ?? "")
            .collection("bills")
            .addDocument(data:
                [
                    BillData.CodingKeys.name.rawValue: accountObject.text ?? "",
                    BillData.CodingKeys.billName.rawValue: friendBillName.text ?? "",
                    BillData.CodingKeys.amount.rawValue: Int(billAmount.text ?? "") ?? "",
                    BillData.CodingKeys.uid.rawValue: currentUser.uid,
                    BillData.CodingKeys.status.rawValue: 1
                ])
    }
}
