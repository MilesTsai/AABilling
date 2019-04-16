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
        
        dataBase
            .collection("users")
            .whereField("displayName", isEqualTo: accountObject.text ?? "")
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
                            
                            let friendBill = document.data()
                            
                            self.bill =
                                BillData(
                                    displayName: friendBill["displayName"] as? String,
                                    billName: friendBill["billName"] as? String,
                                    amount: friendBill["amount"] as? Int,
                                    status: friendBill["status"] as? Int
                                )
                        }
                        self.updateDocument(document: self.friendID ?? "")
                        
                        self.dataBase
                            .collection("users")
                            .document(currentUser.uid)
                            .collection("bills")
                            .addDocument(data:
                                [
                                 BillData.CodingKeys.displayName.rawValue:
                                    self.bill?.displayName ?? "",
                                 BillData.CodingKeys.billName.rawValue:
                                    self.friendBillName.text ?? "",
                                 BillData.CodingKeys.amount.rawValue:
                                    self.billAmount.text ?? "",
                                 BillData.CodingKeys.status.rawValue:
                                    self.bill?.status ?? ""
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
        }
    }
    
    private func updateDocument(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let inviteFriend =
            dataBase
                .collection("users")
                .document(friendID ?? "")
                .collection("friends")
                .document(currentUser.uid)
        
        inviteFriend.setData([
            "status": 1
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
        
//        guard ((accountObject?.text) != nil)
//                && ((friendBillName?.text) != nil)
//                && billName.text != nil else {
//            
//            print("No Bill Informations")
//            
//            let alertController =
//                UIAlertController(
//                    title: "錯誤",
//                    message: "請輸入帳單資訊",
//                    preferredStyle: .alert
//            )
//            
//            let defaultAction =
//                UIAlertAction(
//                    title: "OK",
//                    style: .cancel,
//                    handler: nil
//            )
//            
//            alertController.addAction(defaultAction)
//            
//            self.present(alertController, animated: true, completion: nil)
//            
//            return
    
}
