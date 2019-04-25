//
//  FirebaseManager.swift
//  Project-2
//
//  Created by User on 2019/4/16.
//  Copyright © 2019 Miles. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager {
    
    private init() {}
    
    static let shared = FirebaseManager()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    var user: UserData?
    
    lazy var userReference = Firestore.firestore().collection("users")
    
    func signUp(withEmail: String, password: String, userName: String, view: UIViewController) {
            if withEmail.isEmpty == true {
                let alertController = UIAlertController(
                    title: "錯誤",
                    message: "請輸入信箱與密碼",
                    preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                view.present(alertController, animated: true, completion: nil)
                
            } else {
                Auth.auth().createUser(withEmail: withEmail, password: password) { (_, error) in
                    
                    if error == nil {
                        print("You have successfully signed up")
                        
                        guard let currentUser = Auth.auth().currentUser else { return }
                        self.userReference.document(currentUser.uid).setData(
                            [
                                UserData.CodingKeys.name.rawValue: userName,
                                UserData.CodingKeys.email.rawValue: withEmail,
                                UserData.CodingKeys.storage.rawValue: "",
                                UserData.CodingKeys.uid.rawValue:
                                    currentUser.uid
                            ])
                        
                        self.user = UserData(name: userName, email: withEmail, storage: "", uid: currentUser.uid)
                        
                        if let tabBarVC =
                            UIStoryboard.main.instantiateViewController(
                                withIdentifier:
                                String(describing: TabBarViewController.self))
                                as? TabBarViewController {
                            view.present(tabBarVC, animated: true, completion: nil)
                        }
                    } else {
                        let alertController =
                            UIAlertController(
                                title: "錯誤",
//                                message: "此帳號已被註冊",
                                message: error?.localizedDescription,
                                preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        print(error ?? "")
                        view.present(alertController, animated: true, completion: nil)
                    }
            }
        }
    }
    
    func read() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection("bills").addSnapshotListener { (snapshot, _) in
            
            guard let snapshot = snapshot else { return }
            
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    
    func deleteFriend(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection("friends").document(document).delete()
        
        userReference.document(document).collection("friends").document(currentUser.uid).delete()
        
    }
    
    func deleteBilling(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection("bills").document(document).delete()
        
    }
    
    func deleteFriendBilling(document: String, billId: String) {
        userReference.document(document).collection("bills").document(billId).delete()
        
    }
    
    func updateMyStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection("friends").document(document).updateData(["status": 1])
        
    }
    
    func updateFriendStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        userReference.document(document).collection("friends").document(currentUser.uid).updateData(["status": 1])
    }
    
    func updateMyBillStatus(document: String) {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userReference.document(currentUser.uid).collection("bills").document(document).updateData(["status": 2, "owedAmount": 0])
    }
    
    func updateFriendBillStatus(document: String, billID: String) {
        userReference.document(document).collection("bills").document(billID).updateData(["status": 2, "owedAmount": 0])
    }
}
